# Start from Ubuntu 22.04 latest image
FROM kalfazed/trt-dev:cuda12.1-cudnn8.9-trt8.6

ARG USERNAME

# Install necessary packages
RUN apt-get update && \
    apt-get install -y libeigen3-dev protobuf-compiler libopencv-dev libgflags-dev libglfw3 libglfw3-dev rclone ccache clang-tidy && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory to the new user's home directory
WORKDIR /home/${USERNAME}

# Switch back to root
USER root

ENTRYPOINT service ssh restart && bash
