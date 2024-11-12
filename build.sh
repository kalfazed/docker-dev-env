#!/bin/bash
#
# Check if the shell name are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <shell_name>"
    exit 1
fi

# Get host user information
export SHELLNAME=$1
export USERNAME=$(whoami)
export UID=$(id -u)
export GID=$(id -g)

# Build the Docker image
docker build \
  --build-arg SHELLNAME=$SHELLNAME \
  --build-arg USERNAME=$USERNAME \
  --build-arg UID=$UID \
  --build-arg GID=$GID \
  -t ubuntu22.04-kalfazed:dev \
  .
