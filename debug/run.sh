#!/bin/bash

k8s_api_host=$1
k8s_api_port=$2
k8s_node_name=$3

docker run -it --rm \
    -e "KUBERNETES_SERVICE_HOST=$k8s_api_host" \
    -e "KUBERNETES_SERVICE_PORT=$k8s_api_port" \
    -e "NODE_NAME=$k8s_node_name" \
    -e "INSECURE=1" \
    -v "$(pwd)/serviceaccount_token:/var/run/secrets/kubernetes.io/serviceaccount/token:ro" \
    -v "$(pwd)/playbook.yml:/k8s-node-patcher/playbooks/play1.yml" \
    --network=host \
    localhost/k8s-node-patcher