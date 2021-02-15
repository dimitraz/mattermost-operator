#!/usr/bin/env bash

set -Eeuxo pipefail

# Move the operator container inside Kind container so that the image is
# available to the docker in docker environment.
# Copy the image to the cluster to make a bit more fast to start
docker pull quay.io/presslabs/mysql-operator:0.3.3
docker pull quay.io/presslabs/mysql-operator-sidecar:0.3.3
docker pull quay.io/presslabs/mysql-operator-orchestrator:0.3.3
docker pull minio/k8s-operator:1.0.7

kind load docker-image quay.io/presslabs/mysql-operator:0.3.3
kind load docker-image quay.io/presslabs/mysql-operator-sidecar:0.3.3
kind load docker-image quay.io/presslabs/mysql-operator-orchestrator:0.3.3
kind load docker-image minio/k8s-operator:1.0.7
sleep 10

make mysql-minio-operators

sleep 10

kubectl get pods --all-namespaces
# Build the operator container image.
# This would build a container with tag mattermost/mattermost-operator:test,
# which is used in the e2e test setup below.
make build-image kind-load-image
sleep 5

kubectl get pods --all-namespaces
echo "Ready for testing"
