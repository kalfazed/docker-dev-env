#!/bin/bash

# Check if both image name and container name are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <image_name> <container_name>"
    exit 1
fi

# Assign the arguments to variables
IMAGE_NAME=$1
CONTAINER_NAME=$2

# Check if the container already exists
CONTAINER_EXISTS=$(docker ps -a --format '{{.Names}}' | grep -w "$CONTAINER_NAME")
CONTAINER_RUNNING=$(docker ps --format '{{.Names}}' | grep -w "$CONTAINER_NAME")

if [ "$CONTAINER_EXISTS" ]; then
    if [ "$CONTAINER_RUNNING" ]; then
        echo "$CONTAINER_NAME is already running"
    else
        echo "Starting and attaching to the existing container: $CONTAINER_NAME"
        docker start "$CONTAINER_NAME"
    fi
else
    echo "Creating and starting a new container: $CONTAINER_NAME"
    docker run -dit \
        --name $CONTAINER_NAME \
        -v ~/ghq/:/home/$(whoami)/ghq/ \
        -v ~/data/:/home/$(whoami)/data/ \
        -v ~/Packages/:/home/$(whoami)/Packages/ \
        -p 8000:8000 \
        -p 8080:8080 \
        -p 2222:22 \
        $IMAGE_NAME \
        fish
fi

