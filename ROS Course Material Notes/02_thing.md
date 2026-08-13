# Detailed ROS 2/Gazebo Installation Walkthrough

> A step-by-step companion to [`01_VMware_fusion.md`](01_VMware_fusion.md). Commands and package names should be verified against the current ROS 2 Jazzy and Ubuntu documentation before use.

## Target environment

```text
Intel MacBook Pro
└── VMware Fusion
    └── Ubuntu AMD64
        ├── ROS 2 Jazzy
        ├── Gazebo Harmonic
        ├── RViz2
        ├── Git and VS Code
        └── ROV HiL/SiL workspace
```

Go through creating the Fusion VM and installing Ubuntu 24.04 + ROS 2 Jazzy + Gazebo Harmonic

Absolutely. Let's do this as a clean, reproducible build, and I'll keep the configuration appropriate for your 2017 Intel MacBook Pro and the ROV HIL/SIL project.

One correction to my previous answer first: Ubuntu 24.04.4 LTS is now the current 24.04 point release, so use that rather than 24.04.3. The AMD64 desktop ISO is the correct image for your Intel Mac.

The target will be:

2017 MacBook Pro
        │
        ▼
VMware Fusion
        │
        ▼
Ubuntu 24.04.4 LTS AMD64
        │
        ├── ROS 2 Jazzy
        ├── RViz2
        ├── Gazebo Harmonic
        ├── ros_gz
        ├── Git
        └── VS Code

And later:

                 Raspberry Pi
              NATS Server :4222
                     ▲
                     │
                  network
                     │
                     ▼
MacBook ── VMware ── Ubuntu
                     │
                 ROS 2 / Gazebo
                     │
                 ROV HIL/SIL

I'll use the official documentation for the installation rather than relying on old Gazebo tutorials.

Part 1 — Download the software
1. Ubuntu

Download:

Ubuntu 24.04.4 LTS Desktop AMD64

Ubuntu 24.04.4 AMD64 Desktop ISO

The file should be approximately:

ubuntu-24.04.4-desktop-amd64.iso

The amd64 name is slightly confusing: it means x86-64 and is exactly what you want on an Intel Mac. Ubuntu's release page explicitly identifies AMD64 as the 64-bit PC architecture.

Don't download:

arm64

That's for ARM machines.

Part 2 — VMware Fusion

Your 2017 Mac is an Intel Mac, so Fusion can run an x86-64 Ubuntu guest. Broadcom's Fusion 13 documentation lists Intel Macs among the supported hardware.

If you don't already have Fusion installed, get it from Broadcom:

VMware Fusion installation information

Fusion 13's installer supports both Intel and Apple Silicon, but the guest architecture must match the host architecture; on your Intel Mac, x86-64 guests are what we want.

Part 3 — Create the VM

Open VMware Fusion.

Choose:

Create a New Virtual Machine

Select:

Install from disc or image

Then drag the Ubuntu ISO into the window.

You should see something similar to:

Ubuntu 24.04.4 LTS
ubuntu-24.04.4-desktop-amd64.iso

Continue.

Part 4 — Don't let Fusion over-configure it

Before starting the installation, choose:

Customize Settings

Name it:

ROV-HIL-Ubuntu

I would actually call the VM:

ROV-HIL-Ubuntu24

because you may eventually have another VM for something else.

Part 5 — VM hardware

This is where I'd depart from a generic VMware recommendation.

Your MacBook is old enough that Gazebo is going to be the demanding part, not ROS 2.

CPU

Start with:

Processors: 4

Don't give it all available cores.

If your Mac has a quad-core Intel CPU, this gives Ubuntu enough processing power while leaving macOS usable.

RAM
If your Mac has 16 GB:

Give Ubuntu:

8192 MB
If it has 8 GB:

Use:

4096 MB

but expect Gazebo to be considerably more constrained.

For this project I'd strongly prefer 16 GB host RAM.

Part 6 — Disk

Give the VM:

80 GB

I'd use a dynamically expanding virtual disk if Fusion offers that option.

Why 80 GB?

ROS itself isn't huge, but eventually you'll have:

ROS packages
Gazebo
source code
build/
install/
log/
Git repositories
simulation assets
Gazebo models
Docker images (possibly)

You don't want to be managing a 30 GB VM six weeks into the project.

Part 7 — Network

This is important for the architecture we've been designing.

Go to:

Network Adapter

Choose:

Bridged Networking

Ideally bridge to the interface you're actually using.

For example:

Wi-Fi

rather than NAT.

The resulting topology should eventually look like:

              LAN
               │
       ┌───────┴────────┐
       │                │
 Raspberry Pi         MacBook
 192.168.1.20        192.168.1.10
                         │
                    VMware Fusion
                         │
                         ▼
                   Ubuntu VM
                   192.168.1.30

That will make the later NATS connection extremely straightforward.

Part 8 — Graphics

Open the VM's Display settings.

Enable:

Accelerate 3D Graphics

Give it the maximum graphics memory Fusion allows/configures automatically.

We'll test this properly once Gazebo is installed.

If Gazebo subsequently has graphical problems, we'll revisit this rather than unnecessarily disabling it from the beginning.

Part 9 — Install Ubuntu

Start the VM.

Ubuntu should boot from the ISO.

Choose:

Install Ubuntu

For the installation options, I'd use:

Keyboard

Whatever corresponds to your Mac keyboard.

For a UK keyboard:

English (UK)
Network

Connect to your network.

Installation type

Choose:

Interactive installation

Applications

Choose:

Default selection

rather than Minimal.

You're going to need the desktop environment and graphical tools.

Disk

Because this is a VM:

Erase disk and install Ubuntu

This means the virtual disk, not your Mac's physical disk.

User

I'd make the machine name:

rov-hil

and your username something short, e.g.:

philip

Then let Ubuntu install.

Ubuntu's current 24.04 installation documentation follows essentially this process, and Ubuntu's 24.04.4 image is the current point-release installation media.

Part 10 — First boot

Once Ubuntu starts, open Terminal:

Ctrl + Alt + T

First thing:

sudo apt update
sudo apt full-upgrade

Then:

sudo reboot
Part 11 — VMware integration

After reboot:

sudo apt install open-vm-tools open-vm-tools-desktop

Then:

sudo reboot

This gives you the normal VMware/Ubuntu integration.

Check that you can:

resize the VM window
move the mouse seamlessly
copy/paste text between macOS and Ubuntu

If those work, we're good.

Part 12 — Basic development tools

Before ROS:

sudo apt install -y \
    git \
    curl \
    wget \
    build-essential \
    cmake \
    python3-pip \
    python3-venv \
    python3-dev \
    software-properties-common

Then:

git --version

and:

python3 --version

You should have a functioning development environment.

Part 13 — Install ROS 2 Jazzy

Now we get into the ROS installation.

ROS 2 Jazzy is the correct ROS distribution for Ubuntu 24.04/Noble.

I'd install the Desktop variant because you're going to use:

RViz2
demos
graphical tooling
Gazebo integration

rather than just ROS middleware.

First:

sudo apt install -y software-properties-common
sudo add-apt-repository universe

Then:

sudo apt update

Install the ROS apt repository using the current ROS infrastructure package:

sudo apt install -y curl

Then:

export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F'"' '{print $4}')

Then:

curl -L -o /tmp/ros2-apt-source.deb \
"https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"

Install it:

sudo dpkg -i /tmp/ros2-apt-source.deb

Then:

sudo apt update
sudo apt upgrade

Finally:

sudo apt install ros-jazzy-desktop

The official Jazzy documentation is the authority for this package installation procedure. ROS 2 Jazzy installation documentation

Part 14 — Configure ROS automatically

Rather than typing the ROS setup command every time:

echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc

Then:

source ~/.bashrc

Check:

printenv ROS_DISTRO

You should get:

jazzy

Then:

ros2 --help

If you get the ROS 2 command list, we're alive.

Part 15 — Test ROS 2

Open two terminals.

Terminal 1
ros2 run demo_nodes_cpp talker

You should get messages like:

Publishing: 'Hello World: 1'
Publishing: 'Hello World: 2'
Publishing: 'Hello World: 3'
Terminal 2
ros2 run demo_nodes_py listener

You should see:

I heard: [Hello World: 1]
I heard: [Hello World: 2]
I heard: [Hello World: 3]

Then:

ros2 topic list

You should see:

/chatter
/parameter_events
/rosout

Stop here if this doesn't work.

Don't proceed to Gazebo until ROS itself is working.

Part 16 — Test RViz2

Run:

rviz2

You should get the RViz GUI.

This is an important test because we're running a graphical application inside VMware.

If RViz starts successfully, that's a good sign.

Close it.

Part 17 — Install Gazebo Harmonic

Now we're going to use modern Gazebo, not Gazebo Classic.

This distinction is important.

Don't install packages such as:

gazebo11
gazebo_ros_pkgs

from old tutorials.

Gazebo Classic reached end-of-life in January 2025.

For our stack we're using:

ROS 2 Jazzy
       +
Gazebo Harmonic

Gazebo provides a ROS integration specifically for this newer architecture.

The Harmonic distribution has packages for Ubuntu Noble AMD64.

Install the ROS/Gazebo integration:

sudo apt install ros-jazzy-ros-gz

Then:

sudo apt install gz-harmonic

If the second command reports that the package is already installed or resolves the appropriate Gazebo packages, that's fine.

Part 18 — Test Gazebo by itself

Run:

gz sim

You should get the Gazebo GUI.

Depending on the version, you may see an empty simulation/world.

Check the version:

gz sim --version

We want it to report the Harmonic generation.

If the GUI doesn't appear, don't start changing random graphics settings yet. Tell me exactly what happens.

Part 19 — Test ROS ↔ Gazebo

This is the really important milestone.

We want:

ROS 2
  ↕
ros_gz
  ↕
Gazebo Harmonic

The ros_gz packages provide the integration between ROS 2 and modern Gazebo.

Check that they're installed:

ros2 pkg list | grep ros_gz

You should see packages along the lines of:

ros_gz_bridge
ros_gz_image
ros_gz_sim

Then:

ros2 pkg list | grep gz
Part 20 — Check the ROS/Gazebo environment

Run:

echo $ROS_DISTRO

Expected:

jazzy

Then:

which ros2

Expected:

/opt/ros/jazzy/bin/ros2

And:

which gz

You should get the Gazebo executable location.

Then:

gz sim --version
Part 21 — Install colcon and rosdep

These will become important when we create your actual HIL workspace.

sudo apt install -y \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool

Initialize rosdep:

sudo rosdep init

Then:

rosdep update

If rosdep init tells you it has already been initialized, that's fine.

Part 22 — Create the ROS workspace

Now create the workspace that will eventually become part of your rov-hil repository:

mkdir -p ~/rov-hil/ros2_ws/src

Then:

cd ~/rov-hil/ros2_ws

Don't create the ROV packages yet.

At this stage we simply want:

~/rov-hil/
└── ros2_ws/
    └── src/
Part 23 — Snapshot the VM

This is where I'd stop and make a VMware snapshot.

Shut down Ubuntu:

sudo shutdown now

In VMware Fusion, create a snapshot called:

ROS2-Jazzy-Gazebo-Harmonic-clean

That snapshot represents:

Ubuntu 24.04.4
       +
VMware Tools
       +
ROS 2 Jazzy
       +
RViz2
       +
Gazebo Harmonic
       +
ros_gz
       +
colcon
       +
rosdep

If we subsequently do something stupid while developing the ROV simulator, we can roll back to this state.

Where we should be at this point

The VM should now look like:

ROV-HIL-Ubuntu24
│
├── Ubuntu 24.04.4 LTS
│
├── VMware integration
│
├── Git
├── CMake
├── Python
│
├── ROS 2 Jazzy
│   ├── rclcpp
│   ├── rclpy
│   ├── RViz2
│   ├── rosbag2
│   └── ...
│
├── Gazebo Harmonic
│
├── ros_gz
│
├── colcon
├── rosdep
│
└── ~/rov-hil/
    └── ros2_ws/
        └── src/

And we haven't installed anything ROV-specific yet.

That's deliberate.

The next test I'd do

Before we touch your GitHub repository, I'd make a tiny simulated robot:

             Gazebo Harmonic
                  │
              ROV model
                  │
        ┌─────────┼─────────┐
        │         │         │
       IMU      depth     camera
        │         │         │
        └─────────┼─────────┘
                  │
                ROS 2
                  │
              RViz2

Then we'll prove that:

Gazebo → ROS 2 → RViz2

works inside VMware.

Only after that would I add:

ROS 2 → NATS → Raspberry Pi

and eventually connect that to your ROV Control repository.

That gives us a very clean fault-isolation strategy: if the HIL rig doesn't work, we know whether the problem is VMware, ROS, Gazebo, the simulation, NATS, or the ROV software, rather than having all six variables change at once.
# Detailed ROS 2/Gazebo Installation Walkthrough

> A step-by-step companion to [`01_VMware_fusion.md`](01_VMware_fusion.md). Commands and package names should be verified against the current ROS 2 Jazzy and Ubuntu documentation before use.

## Target environment

```text
Intel MacBook Pro
└── VMware Fusion
    └── Ubuntu AMD64
        ├── ROS 2 Jazzy
        ├── Gazebo Harmonic
        ├── RViz2
        ├── Git and VS Code
        └── ROV HiL/SiL workspace (~/ROV---HiL-and-SiL/)
```
