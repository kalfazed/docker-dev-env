# Start from Ubuntu 22.04 latest image
FROM ubuntu:22.04
ENV TZ=Asia/Tokyo

# Set timezone in case of interation during installation
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update sources.list to use a faster mirror for Japan
RUN sed -i 's|http://archive.ubuntu.com/ubuntu|http://jp.archive.ubuntu.com/ubuntu|g' /etc/apt/sources.list

# Set up arguments for the user and group ID to match the host user
ARG SHELLNAME
ARG USERNAME
ARG UID
ARG GID

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y sudo openssh-server tzdata locales && \
    rm -rf /var/lib/apt/lists/*

# Setup locales
RUN sudo locale-gen en_US.UTF-8 && sudo update-locale LANG=en_US.UTF-8

# Create a group and user with specified UID and GID, matching the host
RUN groupadd --gid ${GID} ${USERNAME} && \
    useradd -m --uid ${UID} --gid ${GID} -s /bin/bash ${USERNAME} && \
    usermod -aG sudo ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:/usr/bin/chsh" >> /etc/sudoers

# Set password as 111
RUN echo "${USERNAME}:111" | chpasswd

# Be able to ssh
EXPOSE 22

# Create a Package directory in the user's home directory
RUN mkdir -p /home/${USERNAME}/Packages

# Copy "my_dot_file" from the build context to the Package directory
COPY my_dot_files /home/${USERNAME}/.dot_files
RUN chown -R ${USERNAME} /home/${USERNAME}/.dot_files

# Switch to user
USER ${USERNAME}

# Install development environment
WORKDIR /home/${USERNAME}/.dot_files
RUN bash install.sh ${SHELLNAME}

# Set the working directory to the new user's home directory
WORKDIR /home/${USERNAME}

# Switch back to root
USER root

ENTRYPOINT service ssh restart && bash
