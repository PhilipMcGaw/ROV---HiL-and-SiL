#!/usr/bin/env zsh
set -euo pipefail
cd "$(dirname "$0")/../ros2_ws"
source /opt/ros/jazzy/setup.zsh
colcon build --symlink-install
