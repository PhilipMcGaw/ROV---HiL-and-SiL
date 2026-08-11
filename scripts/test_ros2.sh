#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../ros2_ws"
source /opt/ros/jazzy/setup.bash
if [ -f install/local_setup.bash ]; then source install/local_setup.bash; fi
colcon test
colcon test-result --verbose
