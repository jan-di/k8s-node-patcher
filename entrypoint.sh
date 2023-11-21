#!/bin/bash

set -eu

echo "Running k8s-node-patcher"

serviceaccount=/var/run/secrets/kubernetes.io/serviceaccount
apiserver_token=$(cat ${serviceaccount}/token)
apiserver_cacert=${serviceaccount}/ca.crt

curl_args=()
if [[ -n "${INSECURE:-}" ]]; then
    scheme="http"
else
    curl_args+=("--cacert" "$apiserver_cacert")
    scheme="https"
fi
apiserver_url=$scheme://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT

echo "Using kubernetes api at $apiserver_url"
mkdir -p /tmp/k8s-node-patcher

# shellcheck disable=SC2048,SC2086
curl ${curl_args[*]} --fail -sS --header "Authorization: Bearer ${apiserver_token}" -X GET -o /tmp/k8s-node-patcher/node.json "${apiserver_url}/api/v1/nodes/${NODE_NAME}" > /dev/null

node_labels_blob=$(jq -r '.metadata.labels | to_entries[] | "\(.key)=\(.value)"' /tmp/k8s-node-patcher/node.json)
playbook_tags=()
for node_label in $node_labels_blob
do
    playbook_tags+=("$node_label")
done


echo "Preparing Ansible"
ansible --version

echo "Running on node ${NODE_NAME} with tags:"
for tag in "${playbook_tags[@]}"
do
    echo "- $tag"
done

playbook_tagarg=$(printf ",%s" "${playbook_tags[@]}")
playbook_tagarg=${playbook_tagarg:1}

# Run ansible playbooks
for playbook in /k8s-node-patcher/playbooks/*
do
    echo "Run Ansible playbook $playbook"
    ansible-playbook --tags "$playbook_tagarg" "$playbook"
done

# Sleep for all eternity
echo "Going to sleep.."
trap "echo signal;exit 0" SIGINT
while :
do
    sleep 1
done