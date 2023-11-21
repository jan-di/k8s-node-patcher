# k8s-node-patcher

Someone has to do the dirty stuff 🔧

```bash
docker build . -t localhost/k8s-node-patcher

# Proxy an existing kubernetes cluster via kubectl
kubectl proxy --port=8011 --accept-hosts '.*'

# Run patcher locally
cd debug
bash run.sh host.docker.internal 8011 my-node1
```
