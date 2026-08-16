# Day 0 — Build the ROS 2 / Gazebo workstation

## Objective

Create a known-good Ubuntu development and simulation environment. This is a workstation exercise, not an ROV integration exercise.

## Target

```text
Intel MacBook Pro
    ↓
VMware Fusion
    ↓
Ubuntu 24.04 LTS AMD64
    ├── ROS 2 Jazzy
    ├── Gazebo Harmonic
    ├── RViz2
    ├── ros_gz
    ├── colcon
    └── Git / SSH
```

Use the ROS-supported Ubuntu/ROS pairing. Do not select an Ubuntu release simply because it is newer.

## VM baseline

Start with approximately:

- 4 CPU cores;
- 6–8 GB RAM where the host permits;
- 60–80 GB dynamically allocated disk;
- bridged networking when direct LAN communication is required; and
- 3D acceleration enabled initially.

The VM is the HiL/SiL environment boundary. Do not install Cockpit, Control or Datalogger application runtimes here.

## Shell

Use ZSH for ROS work:

```zsh
source /opt/ros/jazzy/setup.zsh
```

If required, persist it with:

```zsh
echo 'source /opt/ros/jazzy/setup.zsh' >> ~/.zshrc
source ~/.zshrc
```

## Verification

Check:

```zsh
printenv ROS_DISTRO
ros2 --help
rviz2
gz sim
```

`ROS_DISTRO` should report `jazzy`.

## Development tools

Install the required tools using the current ROS 2 Jazzy installation instructions. Avoid unnecessary system changes and do not use `apt autoremove` as a routine step; it is only a cleanup operation when packages are no longer required.

## Workspace

Create the project workspace:

```zsh
mkdir -p "$HOME/ROV - HiL-and-SiL/ros2_ws/src"
```

Do not build from `ros2_ws/src`; colcon must be run from `ros2_ws`.

## Day 0 exit criteria

- [ ] Ubuntu 24.04 LTS AMD64 is running reliably in VMware Fusion.
- [ ] ROS 2 Jazzy is sourced successfully with ZSH.
- [ ] RViz2 starts.
- [ ] Gazebo starts.
- [ ] `colcon` is available.
- [ ] Git and SSH are available.
- [ ] The HiL/SiL workspace can be created.
- [ ] The VM is in a known-good state suitable for a baseline snapshot.

After the exit criteria pass, take a VMware snapshot.
