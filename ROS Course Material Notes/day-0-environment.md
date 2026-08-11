# Day 0 — Prepare the development environment

## Objective

Create an independent Ubuntu AMD64 workstation in VMware Fusion, with ROS 2 Jazzy, Gazebo Harmonic, RViz2, Git, and the required development tools.

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
