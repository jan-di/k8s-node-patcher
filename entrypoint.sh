#!/bin/bash

set -eu

echo "Running k8s-node-patcher"

ansible --version

# Sleep for all eternity
trap "echo signal;exit 0" SIGINT
while :
do
    sleep 1
done