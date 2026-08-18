#!/usr/bin/env zsh
set -euo pipefail
cd "$(dirname "$0")/../ros2_ws"
source /opt/ros/jazzy/setup.zsh
if [[ -f install/local_setup.zsh ]]; then source install/local_setup.zsh; fi
colcon test
colcon test-result --verbose
