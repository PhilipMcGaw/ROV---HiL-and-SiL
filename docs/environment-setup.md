# Environment setup

The documented target environment is an Ubuntu AMD64 virtual machine running under VMware Fusion on the 2017 Intel MacBook Pro. The same ROS 2/Gazebo stack may instead run on dedicated physical hardware.

This repository is self-contained at the machine/VM level. It does not use the Python or portable-Python installation support from the Cockpit, Control, or Datalogger repositories.

Target software:

- Ubuntu 24.04 LTS AMD64
- ROS 2 Jazzy
- Gazebo Harmonic
- `ros_gz`
- RViz2
- `colcon`

The detailed installation notes are retained in `ROS Course Material Notes/`. They are working notes and may contain observations from the actual installation; verify package availability against the selected Ubuntu/ROS release before automating setup.

The first milestone is a working ROS 2 and Gazebo installation, followed by a trivial simulated model. The MQTT bridge should be added only after the local simulation pipeline is proven.
