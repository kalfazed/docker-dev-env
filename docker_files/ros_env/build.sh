#!/usr/bin/bash

set -e

# Get host user information
export IMGNAME=$1
export SHELLNAME=$2
export USERNAME=$(whoami)
export USERID=$(id -u)
export GROUPID=$(id -g)

# Build the Docker image
echo "Building bag_converter Docker image..."

# Build the image from parent directory
docker build \
  --build-arg SHELLNAME=$SHELLNAME \
  --build-arg USERNAME=$USERNAME \
  --build-arg USERID=$USERID \
  --build-arg GROUPID=$GROUPID \
  -t $IMGNAME \
  .

echo "Docker image built successfully: $IMGNAME"
