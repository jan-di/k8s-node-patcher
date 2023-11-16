#!/bin/bash

set -eu

echo "Running k8s-node-patcher"

apiserver_url=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
serviceaccount=/var/run/secrets/kubernetes.io/serviceaccount
apiserver_token=$(cat ${serviceaccount}/token)
apiserver_cacert=${serviceaccount}/ca.crt

mkdir -p /tmp/k8s-node-patcher

curl --cacert "$apiserver_cacert" --header "Authorization: Bearer ${apiserver_token}" -X GET "${apiserver_url}/api/v1/nodes" -o /tmp/k8s-node-patcher/node.json

ansible --version

# Sleep for all eternity
trap "echo signal;exit 0" SIGINT
while :
do
    sleep 1
done