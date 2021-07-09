#!/bin/bash

set -uex

ROOT=$(cd "$(dirname "$0")" && cd .. && pwd)
GOVERSION=$1
TAG=${USERNAME}/codebuild-golang:${GOVERSION}-${BASE_IMAGE}-${BASE_IMAGE_VERSION}

# build
cd "$ROOT"
docker build "$WORKDIR/${BASE_IMAGE_VERSION}/go$GOVERSION" --tag "$TAG"

if [[ ${GITHUB_REF} = 'refs/heads/main' ]]; then
    # Publish to the Docker Hub
    printenv PASSWORD | docker login -u "$USERNAME" --password-stdin
    docker push "$TAG"
    docker logout
fi
