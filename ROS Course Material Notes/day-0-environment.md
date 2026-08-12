# Day 0 — Prepare the development environment

## Objective

Create an independent Ubuntu AMD64 workstation in VMware Fusion, with ROS 2 Jazzy, Gazebo Harmonic, RViz2, Git, and the required development tools.

## Do not select Ubuntu by recency alone

Do not install the newest Ubuntu LTS simply because it is the latest release. ROS 2 distributions are released and tested against specific Ubuntu versions, and Gazebo, `ros_gz`, binary packages, and build tools depend on that compatibility. A newer Ubuntu release may have no supported ROS binaries yet, or may require source builds and unverified workarounds.

Use the Ubuntu and ROS 2 pairing stated in the current ROS 2 support matrix. This course currently targets Ubuntu 24.04 LTS AMD64 with ROS 2 Jazzy and Gazebo Harmonic. If that target changes, update the course documentation and verify the complete pairing before rebuilding the VM.

```text
Intel MacBook Pro → VMware Fusion → Ubuntu AMD64
                                      ├── ROS 2 Jazzy
                                      ├── Gazebo Harmonic
                                      ├── RViz2
                                      └── ROV HiL/SiL workspace
```

Verify the installation with:

```bash
ros2 --version
gz sim
rviz2
```

Do not connect the Raspberry Pi or real propulsion at this stage.
