#!/bin/bash

set -uex

ROOT=$(cd "$(dirname "$0")" && cd .. && pwd)
GOVERSION=$1
TAG=${USERNAME}/codebuild-golang:${GOVERSION}-${BASE_IMAGE}-${BASE_IMAGE_VERSION}
PACKAGE=docker.pkg.github.com/${GITHUB_REPOSITORY}/go${GOVERSION}-${BASE_IMAGE}-${BASE_IMAGE_VERSION}:latest

# build
cd "$ROOT"
docker build "$WORKDIR/${BASE_IMAGE_VERSION}/go$GOVERSION" --tag "$TAG"

if [[ ${GITHUB_REF} = 'refs/heads/master' ]]; then
    # Publish to the Docker Hub
    printenv PASSWORD | docker login -u "$USERNAME" --password-stdin
    docker push "$TAG"
    docker logout

    # Publish to the GitHub package registry
    printenv TOKEN | docker login docker.pkg.github.com -u "$USERNAME" --password-stdin
    docker tag "$TAG" "$PACKAGE"
    docker push "docker.pkg.github.com/$GITHUB_REPOSITORY$PACKAGE"
    docker logout docker.pkg.github.com
fi
