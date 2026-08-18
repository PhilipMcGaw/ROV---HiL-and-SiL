# ROS 2 workspace

The workspace is `ros2_ws/` and is built with `colcon` after sourcing the installed ROS distribution:

```bash
cd ros2_ws
source /opt/ros/jazzy/setup.zsh
colcon build --symlink-install
source install/local_setup.zsh
```

Generated `build/`, `install/`, and `log/` directories are excluded from version control. Source packages belong under `ros2_ws/src/`.
