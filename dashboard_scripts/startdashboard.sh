#!/bin/bash -ex
cd `dirname $(readlink -f "$0")`

[ -z "$1" ] && echo "No kube master provided" && exit 1
SSHCMD="ssh root@${1}"

cleanup() {
    $SSHCMD "pkill -9 kubectl"
}

trap cleanup SIGINT

ssh-copy-id root@${1}

$SSHCMD "[ ! -d 'dashboard' ] && mkdir dashboard ||:"
scp -r ontarget/* root@${1}:dashboard/.
$SSHCMD "./dashboard/apply_users.sh"
$SSHCMD "./dashboard/getadmintoken.sh"

echo "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"

ssh -L localhost:8001:127.0.0.1:8001 root@${1} "kubectl proxy"
