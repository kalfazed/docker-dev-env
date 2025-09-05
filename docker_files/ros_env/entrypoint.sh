#!/usr/bin/bash

source "/opt/ros/$ROS_DISTRO/setup.bash"
service ssh restart && fish
# source /opt/drs/install/setup.bash
# exec "$@"
