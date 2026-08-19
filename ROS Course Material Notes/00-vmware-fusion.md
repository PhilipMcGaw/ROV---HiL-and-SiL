# VMware Fusion — Ubuntu ROS 2 / Gazebo HIL/SIL Workstation

## Purpose

This document is a generic setup guide for an Ubuntu 24.04 LTS virtual machine running in VMware Fusion. The VM is intended as the development and simulation workstation for a ROS 2 / Gazebo HIL/SIL environment.

The guide deliberately avoids personal usernames and machine-specific paths. Use the current Ubuntu user's home directory (`$HOME`) wherever possible.

## Target stack

- VMware Fusion
- Ubuntu 24.04 LTS Desktop
- AMD64 / x86-64 guest on an Intel Mac
- ROS 2 Jazzy
- Gazebo Harmonic
- `ros-jazzy-ros-gz`
- RViz2
- `colcon`
- Git / SSH
- NATS client connectivity for the HIL/SIL architecture

The VM is a HiL/SiL workstation. It does not host the Cockpit, Control, or Datalogger application runtimes.

---

# 1. Create the virtual machine

Use the **Ubuntu 24.04 LTS Desktop AMD64** image. On an Intel Mac, use x86-64/AMD64, not ARM64.

Recommended starting configuration:

| Setting | Recommendation |
|---|---|
| CPU | 4 cores |
| RAM | 6–8 GB |
| Disk | 60–80 GB |
| Network | Bridged |
| Graphics | 3D acceleration enabled initially |
| Firmware | EFI |
| Guest OS | Ubuntu 64-bit |

Do not allocate every host CPU core to the VM; macOS and VMware Fusion still need host resources.

If the host has 16 GB RAM, 8 GB for the VM is a reasonable starting point. With 8 GB total host RAM, use approximately 4 GB and expect Gazebo rendering to be the limiting factor.

## Display / Retina Macs

If the Ubuntu desktop looks soft or fuzzy on a Retina display, check **VMware Fusion → Virtual Machine → Settings → Display** for a Retina/full-resolution option and enable 3D acceleration.

Inside Ubuntu, check **Settings → Displays**. Prefer a high virtual resolution and leave **Fractional Scaling** disabled initially. Do not use fractional scaling to compensate for an incorrectly configured VM display.

---

# 2. Install Ubuntu

Install Ubuntu 24.04 LTS Desktop using the normal desktop installation.

Ubuntu Desktop is appropriate because the workstation will use:

- RViz2
- Gazebo
- graphical debugging
- terminals
- VS Code or another graphical editor

---

# 3. Configure VMware networking

Use **Bridged Networking** rather than NAT when the VM needs to communicate directly with other machines on the LAN.

A typical arrangement is:

```text
                    LAN
                     │
          ┌──────────┴──────────┐
          │                     │
    Raspberry Pi             Host Mac
          │                     │
       NATS server         VMware Fusion
                                │
                                ▼
                           Ubuntu VM
```

Bridged networking gives the VM its own address on the LAN and makes later hardware integration straightforward.

---

# 4. Optional desktop configuration

For a dedicated development VM, automatic login and disabling the guest screen lock may be convenient. These are optional and should not be treated as project requirements.

To prevent the desktop from locking or blanking:

```bash
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0
```

Do not use these settings on a shared or unattended system unless the security implications are understood.

---

# 5. Update the Ubuntu installation

Run the package update/upgrade sequence before installing additional software:

```bash
sudo apt update
sudo apt full-upgrade
```

`apt update` refreshes the package index. `apt full-upgrade` installs available updates and handles dependency changes.

After package installation or removal, clean up packages that are no longer required:

```bash
sudo apt autoremove
```

The normal order is therefore:

```text
sudo apt update
        ↓
install / upgrade packages
        ↓
sudo apt autoremove
```

Do not run `apt autoremove` as part of the initial update step. It is a cleanup operation, not a replacement for updating the package index.

---

# 6. Install VMware guest tools

Ubuntu 24.04 uses the Ubuntu-packaged `open-vm-tools` packages.

Install them with:

```bash
sudo apt install open-vm-tools open-vm-tools-desktop
```

Then reboot:

```bash
sudo reboot
```

These packages provide VMware integration such as mouse integration, display resizing and clipboard support.

If the packages are already installed, no further action is required.

---

# 7. Install basic development tools

Install the common development dependencies:

```bash
sudo apt install \
  build-essential \
  cmake \
  curl \
  git \
  wget \
  python3-dev \
  python3-pip \
  python3-venv \
  software-properties-common
```

Enable the Ubuntu Universe repository if it is not already enabled:

```bash
sudo add-apt-repository universe
```

Refresh the package index after changing repositories:

```bash
sudo apt update
```

---

# 8. Install ROS 2 Jazzy

Use the official ROS 2 Debian packages rather than building ROS 2 from source.

Install the ROS repository package:

```bash
sudo apt install curl -y

export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F'"' '{print $4}')

curl -L -o /tmp/ros2-apt-source.deb \
  "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"

sudo dpkg -i /tmp/ros2-apt-source.deb
```

Refresh the package index after adding the ROS repository:

```bash
sudo apt update
```

Install the desktop distribution:

```bash
sudo apt install ros-jazzy-desktop
```

`ros-jazzy-desktop` is appropriate for this workstation because it includes RViz2 and the standard graphical ROS tooling.

Optionally clean up afterwards:

```bash
sudo apt autoremove
```

---

# 9. Configure the ROS environment

For Zsh:

```zsh
echo "source /opt/ros/jazzy/setup.zsh" >> ~/.zshrc
source ~/.zshrc
```

For Zsh:

```bash
echo "source /opt/ros/jazzy/setup.zsh" >> ~/.zshrc
source ~/.zshrc
```

Use the configuration for the shell you actually use. Do not add both unless there is a reason to support both shells.

Verify the installation:

```bash
printenv ROS_DISTRO
ros2 --help
ros2 doctor
```

`ROS_DISTRO` should report:

```text
jazzy
```

---

# 10. Test ROS 2 before installing project software

First verify the base ROS 2 installation independently of the ROV project.

### Terminal 1

```bash
ros2 run demo_nodes_cpp talker
```

### Terminal 2

```bash
ros2 run demo_nodes_py listener
```

The listener should receive messages from the talker.

Then check the active topics:

```bash
ros2 topic list
```

Typical output includes:

```text
/chatter
/parameter_events
/rosout
```

Do not proceed to project-specific debugging until this basic ROS test works.

---

# 11. Install Gazebo Harmonic and ROS/Gazebo integration

ROS 2 Jazzy is paired with Gazebo Harmonic.

Install the ROS/Gazebo integration package:

```bash
sudo apt install ros-jazzy-ros-gz
```

Test Gazebo:

```bash
gz sim
```

The Gazebo GUI should start.

If Gazebo has graphical problems, check VMware Fusion's 3D acceleration and guest display configuration before changing the ROS installation.

---

# 12. Install ROS development tools

Install the tools required to create and build ROS workspaces:

```bash
sudo apt install \
  python3-colcon-common-extensions \
  python3-rosdep \
  python3-vcstool
```

Initialise `rosdep` once:

```bash
sudo rosdep init
rosdep update
```

If `rosdep init` reports that it has already been initialised, do not repeat it. Run:

```bash
rosdep update
```

---

# 13. Optional shell customisation

The following is optional and is not required by ROS, Gazebo or the HIL/SIL environment.

Install useful command-line tools:

```bash
sudo apt install nano zsh htop dialog
```

If Zsh is required as the default shell:

```bash
chsh -s "$(which zsh)"
```

If using Oh My Zsh, treat it as user-specific shell configuration rather than a project dependency.

Avoid making personal shell customisation, banners or themes part of the reproducible HIL/SIL setup.

---

# 14. SSH access to the VM

Install the SSH server if the VM is to be administered remotely from the host:

```bash
sudo apt install openssh-server
```

Use an Ed25519 key for laptop-to-VM authentication and add the laptop's public key to:

```text
~/.ssh/authorized_keys
```

Connect using:

```bash
ssh <username>@<vm-address>
```

Do not copy private keys into the VM repository.

---

# 15. GitHub access from the VM

GitHub access is separate from laptop-to-VM SSH access.

Generate an Ed25519 key inside the VM:

```bash
ssh-keygen -t ed25519 -C "<username>@rov-hil-sil"
```

Add the public key to the appropriate GitHub account and test authentication:

```bash
ssh -T git@github.com
```

Check the repository remote before making changes:

```bash
git remote -v
```

The private key must remain inside the VM and must never be committed to the repository.

---

# 16. Clone the HIL/SIL repository

Clone the repository into the current user's home directory using `$HOME` rather than a hard-coded username:

```bash
git clone <repository-ssh-url> "$HOME/robots/ROV---HiL-and-SiL"
```

The ROS workspace should live inside the HIL/SIL repository rather than as a separate workspace in the user's home directory.

A suitable layout is:

```text
ROV---HiL-and-SiL/
├── README.md
├── configs/
├── docs/
├── ros2_ws/
│   └── src/
├── scenarios/
├── scripts/
└── tests/
```

Generated ROS workspace directories should not be committed:

```text
ros2_ws/build/
ros2_ws/install/
ros2_ws/log/
```

Add them to `.gitignore`.

---

# 17. Verify ROS ↔ Gazebo integration

Before creating the ROV simulation, prove that the ROS/Gazebo pipeline works independently.

The intended basic pipeline is:

```text
Gazebo
  │
  ├── simulated sensors
  └── simulated actuators
          │
          ▼
        ROS 2
          │
          ▼
        RViz2
```

A useful first milestone is a simple model with an IMU and depth sensor:

```text
Gazebo
  │
  ├── simulated IMU
  └── simulated depth sensor
          │
          ▼
        ROS 2
          │
          ▼
        RViz2
```

Do not start with a complex underwater environment. Establish the basic simulation pipeline first.

---

# 18. HIL/SIL architecture

The VM contains the simulation and HIL/SIL development environment:

```text
Ubuntu VM
├── ROS 2
├── Gazebo
├── RViz2
├── HIL/SIL ROS packages
└── NATS client
```

**NATS is the chosen communication middleware.**

NATS should be treated as an explicit part of the project architecture, not as an undecided future transport. The VM uses a NATS client; the NATS server/source of truth is associated with the Raspberry Pi when hardware is introduced.

Conceptually:

```text
                    HIL/SIL VM
              ┌─────────────────────┐
              │                     │
              │      Gazebo         │
              │        │            │
              │        ▼            │
              │      ROS 2          │
              │        │            │
              │        ▼            │
              │   HIL bridge        │
              │        │            │
              └────────┼────────────┘
                       │
                      NATS
                       │
                       ▼
                Raspberry Pi
                       │
                  NATS Server
```

The exact NATS subjects and message definitions should be defined by the project architecture rather than embedded directly into Gazebo models or individual applications.

---

# 19. Gazebo performance in VMware Fusion

Gazebo is likely to be the most demanding part of this environment on an older Intel Mac.

The rendering path is effectively:

```text
macOS
  ↓
VMware Fusion
  ↓
Ubuntu
  ↓
Gazebo rendering
```

Leave **3D acceleration enabled** initially.

If Gazebo is unstable or rendering is poor:

1. Confirm `open-vm-tools` and `open-vm-tools-desktop` are installed.
2. Check the Ubuntu display resolution and scaling.
3. Check VMware Fusion's 3D acceleration settings.
4. Only then test alternative graphics configurations.

Start simulation development with a simple environment:

- simple tank/environment
- ROV body
- six thrusters
- IMU
- depth sensor
- camera

Increase scene and physics complexity only after the basic simulation is stable.

---

# 20. Create a known-good baseline

Once the following have been verified:

- Ubuntu 24.04 LTS
- VMware guest integration
- correct display behaviour
- ROS 2 Jazzy
- ROS 2 demo nodes
- Gazebo Harmonic
- ROS/Gazebo integration
- RViz2
- Git
- SSH access
- HIL/SIL repository

create a **VMware Fusion snapshot**.

This provides a known-good baseline before adding project-specific ROS packages, simulation models, Python dependencies or NATS configuration.

If later development breaks the environment, restore the snapshot rather than rebuilding the workstation from scratch.

---

# Command-order summary

For package management, keep the sequence predictable:

```bash
# Refresh package information
sudo apt update

# Bring the system up to date
sudo apt full-upgrade

# Install the required packages
sudo apt install <packages>

# Refresh again after adding/changing repositories
sudo apt update

# Optional cleanup after package changes
sudo apt autoremove
```

Do not routinely use both `apt upgrade` and `apt full-upgrade` in the same setup sequence. For this workstation, `full-upgrade` is sufficient for the initial system update.

When a repository is added, always run `apt update` before installing packages from that repository.

---

# Result

The finished VM should provide a generic, reproducible development environment for the ROV HIL/SIL project:

```text
VMware Fusion
└── Ubuntu 24.04 LTS
    ├── ROS 2 Jazzy
    ├── Gazebo Harmonic
    ├── RViz2
    ├── colcon / rosdep / vcstool
    ├── Git / SSH
    ├── NATS client
    └── ~/robots/ROV---HiL-and-SiL
```



