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

The first milestone is a working ROS 2 and Gazebo installation, followed by a trivial simulated model. The NATS/ROS 2 bridge should be added only after the local simulation pipeline is proven.
# Ubuntu and ROS compatibility

## Repository location

On the Linux VM, clone the HiL/SiL repository below the VM user's home directory as `~/robots/ROV---HiL-and-SiL`. On macOS, use a user-selected workspace beneath the home directory, for example `~/Projects/ROV/ROV---HiL-and-SiL`. Keep the other ROV repositories as sibling directories where they are needed. These locations are documented defaults; scripts and ROS workspace commands must remain usable if the repository is moved.

Do not choose the newest Ubuntu LTS automatically when preparing a ROS workstation. ROS 2 distributions support defined Ubuntu releases, and the supported pairing determines whether ROS packages, Gazebo, `ros_gz`, RViz2, and `colcon` can be installed and used consistently.

Installing a newer, unsupported Ubuntu release can result in missing binary packages, incompatible dependencies, source-build requirements, or undocumented workarounds. Select the Ubuntu release from the ROS 2 distribution support matrix instead of selecting it by date.

The current HiL/SiL course target is Ubuntu 24.04 LTS AMD64 with ROS 2 Jazzy and Gazebo Harmonic. Verify official support before creating a new VM, particularly when the course target or ROS distribution changes.
