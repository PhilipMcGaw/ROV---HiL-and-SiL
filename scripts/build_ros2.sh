#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../ros2_ws"
source /opt/ros/jazzy/setup.bash
colcon build --symlink-install
