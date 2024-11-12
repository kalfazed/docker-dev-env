#!/bin/bash

IMAGE_NAME=""
CONTAINER_NAME=""

function usage() {
    echo "Usage: $0 general --image_name <image_name> --container_name <CONTAINER_NAME>"
    echo "Usage: $0 cuda --image_name <image_name> --container_name <CONTAINER_NAME>"
    exit 1
}

function check_cmd_format() {
  if [[ $# -lt 1 ]]; then
      usage
  fi

  mode="$1"
  shift 

  while [[ "$#" -gt 0 ]]; do
      case "$1" in
          --image_name)
              IMAGE_NAME="$2"
              shift 2
              ;;
          --container_name)
              CONTAINER_NAME="$2"
              shift 2
              ;;
          *)
              usage
              ;;
      esac
  done

  if [[ "$mode" != "general" && "$mode" != "cuda" ]]; then
      echo "Wrong mode"
      usage
  fi

  if [[ ( -z "$IMAGE_NAME" || -z "$CONTAINER_NAME" ) ]]; then
      echo "missing args"
      usage
  fi
}

function create_cuda_container () {
    echo "Creat and start a new cuda container: $2"
    docker run -dit \
        --name $2 \
        --gpus all \
        -v ~/ghq/:/home/$(whoami)/ghq/ \
        -v ~/data/:/home/$(whoami)/data/ \
        -v ~/Packages/:/home/$(whoami)/Packages/ \
        -p 8000:8000 \
        -p 8080:8080 \
        -p 2222:22 \
        $1 \
        fish
}

function create_general_container () {
    echo "Creat and start a new general container: $2"
    docker run -dit \
        --name $2 \
        -v ~/ghq/:/home/$(whoami)/ghq/ \
        -v ~/data/:/home/$(whoami)/data/ \
        -v ~/Packages/:/home/$(whoami)/Packages/ \
        -p 8000:8000 \
        -p 8080:8080 \
        -p 2222:22 \
        $1 \
        fish
}

function main() {
  check_cmd_format "$@"

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
    if [[ "$mode" == "cuda" ]]; then
      create_cuda_container $IMAGE_NAME $CONTAINER_NAME
    elif [[ "$mode" == "general" ]]; then
      create_general_container $IMAGE_NAME $CONTAINER_NAME
    fi
  fi
}

main "$@"
