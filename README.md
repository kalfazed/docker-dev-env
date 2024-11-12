# Building Docker Environment
This repository contains docker related configs to quickly build development environment

## Build a customized docker image from Dockerfile
Clone the repository with submodules
```shell
git clone --recurse-submodules git@github.com:kalfazed/fs-perc-train.git
git submodule update --remote
```
Please use following script to build the docker image
```shell
bash ./build.sh <image_name> <shell_name>
```
To make sure both container and host have same privilege to modify the shared directory, the current user will be created inside the docker image in default.

Besides, please change your prefereed base image in `Dockerfile`
```shell
FROM ubuntu:22.04
```
For CUDA/TensorRT development, it is recommanded to choose base image from NGC. Fore more detail about NGC, please visit this [link](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda)


You can also change the TZ and source.list while apt-get as follows in `Dockerfile`.
```shell
ENV TZ=Asia/Tokyo
RUN sed -i 's|http://archive.ubuntu.com/ubuntu|http://jp.archive.ubuntu.com/ubuntu|g' /etc/apt/sources.list
```

In default, some helpful tools and configurations are installed from [my_dot_files](https://github.com/kalfazed/my_dot_files). It contains a lot of features to accelearte your develops.


## Create a container based on the image
Please use following script to launch a container
```shell
bash ./run.sh <image_name> <contaner_name>
```
It will launch a container in the background. You can attach to it using `docker attach`. Since the ssh server is installed, you can also `ssh` to the 
container using `ssh ${username}@ip -p 2222`.

In default, the container mount following directories from the host:
```shell
-v ~/ghq/:/home/$(whoami)/ghq/ \
-v ~/data/:/home/$(whoami)/data/ \
-v ~/Packages/:/home/$(whoami)/Packages/ \
```
Please customize them as you prefer.