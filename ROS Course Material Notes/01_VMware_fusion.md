# VMware Fusion ROS 2/Gazebo Workstation

> Setup notes for a 2017 Intel MacBook Pro running the ROV HiL/SiL environment in an Ubuntu virtual machine.

## Important notes

- Use an **AMD64/x86-64** Ubuntu image on an Intel Mac; do not use ARM64.
- The target stack is Ubuntu 24.04 LTS, ROS 2 Jazzy, Gazebo Harmonic, `ros_gz`, RViz2, and `colcon`.
- These are working notes. Confirm current official installation instructions before running commands.
- HiL/SiL runs independently in its own VM or dedicated machine; it does not use the Cockpit, Control, or Datalogger Python runtimes.

Yes. Given that your MacBook Pro is a 2017 Intel machine, I would actually be quite happy using VMware Fusion for this. It avoids trying to run ROS 2 natively on macOS and gives us the Ubuntu environment that ROS 2 and Gazebo are designed around.

For your ROV HIL/SIL project, I'd build the VM specifically as a ROS/Gazebo development workstation, rather than installing a generic Ubuntu desktop and then adding ROS later.

My recommended stack

2017 MacBook Pro
Intel x86-64
        │
        ▼
VMware Fusion
        │
        ▼
Ubuntu 24.04 LTS x86-64
        │
        ├── ROS 2 Jazzy
        │
        ├── Gazebo Harmonic
        │
        ├── ros_gz
        │
        ├── colcon
        │
        ├── RViz2
        │
        └── your ROV-HIL repository

This is currently the sensible combination: ROS 2 Jazzy + Ubuntu 24.04 + Gazebo Harmonic. Gazebo's documentation explicitly recommends this combination for new users.

1. Create the VM

I'd use Ubuntu 24.04 LTS Desktop, 64-bit Intel/AMD.

Your 2017 Mac is Intel, so you want:

Architecture: amd64 / x86_64 (not ARM.)

ROS 2 Jazzy officially supports Ubuntu Noble 24.04 on 64-bit x86.

For the VM, I'd start with:

Setting	Recommendation
CPU	4 cores
RAM	6–8 GB
Disk	60–80 GB
Network	Bridged
Graphics	3D acceleration enabled initially
Firmware	EFI
Guest OS	Ubuntu 64-bit

If your Mac has 16 GB RAM, I'd give the VM 8 GB.

If it only has 8 GB, give it 4 GB and accept that Gazebo will be the limiting factor.

I would not give the VM every CPU core. Your Mac still needs resources for VMware, macOS and everything else running on the host.

VMware Fusion supports Intel Macs, and Fusion 13 supports Intel Macs that support the relevant macOS versions.

2. Install Ubuntu

Download the Ubuntu 24.04 LTS desktop ISO and create a new VM in Fusion. __(I installed Ubuntu 24.04 LTS.)__

Ubuntu Desktop - https://ubuntu.com/download/desktop

I'd choose the normal desktop installation rather than Ubuntu Server.

That's important because you're going to be using:

RViz
Gazebo
visual debugging
terminals
VS Code
graphical development tools
3. VMware networking

This is particularly important for your architecture.

I'd configure the VM's network adapter as:

Bridged Networking

rather than NAT.

That gives you something approximately like:

                     Home/Lab LAN
                         │
             ┌───────────┴───────────┐
             │                       │
        Raspberry Pi              MacBook
        192.168.1.x               192.168.1.x
             │                       │
          NATS :4222          VMware Fusion
                                     │
                                     ▼
                              Ubuntu VM
                              192.168.1.x

This means the Ubuntu VM can directly communicate with the Pi.

That's much nicer for your eventual:

ROS 2 ↔ NATS ↔ ROV Control

architecture.

Fusion supports selecting the host interface when using bridged networking.

3.1 Auto Login

Auto-login and no guest screen lock are deliberate for this personal VM. The
host laptop is encrypted and protected by the laptop's credentials, so it is
the security boundary for the VM. Reconsider this configuration if the VM is
shared, left unattended, or made accessible remotely.

If you want the machine to never lock or blank:

gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0


4. Install VMware tools

Once Ubuntu is running:

sudo apt update
sudo apt upgrade
sudo apt autoremove

Then:

sudo apt install open-vm-tools open-vm-tools-desktop

Ubuntu 24.04 uses open-vm-tools rather than the old VMware Tools installer. VMware explicitly recommends this approach for Ubuntu 24.04.

        ** These were already installed at this point **

Then reboot:

    sudo reboot

This gives you much better:

 * mouse integration
 * display resizing
 * clipboard integration
 * VM integration


5. Install ROS 2 Jazzy

I would use the official deb packages, not compile ROS 2 from source.

The official ROS documentation has the current Jazzy Ubuntu installation procedure.

The important initial setup is:

sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository universe

Then install the ROS repository:

sudo apt install curl

export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F'"' '{print $4}')

curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"

sudo dpkg -i /tmp/ros2-apt-source.deb

Then:

sudo apt update
sudo apt upgrade
sudo apt full-upgrade

sudo apt install git curl wget build-essential cmake python3-pip python3-venv python3-dev software-properties-common
sudo apt install software-properties-common

And I'd install:

sudo apt install ros-jazzy-desktop

For your application, desktop is worthwhile because it gives you RViz and the graphical tooling.


## Optional personal shell preferences

The following steps are not required for ROS 2, Gazebo, or the HiL/SiL
environment. They are personal preferences. Zsh is also the default shell on
modern macOS, so using it in the VM keeps the terminal experience consistent
with the host laptop.

`neofetch` is included to provide a clear shell banner that identifies the
machine currently in use. This is useful when working across the host and VM.

Set up the optional shell environment:

sudo apt install nano zsh git neofetch htop dialog rcm

install ohmyzsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

edit .zshrc and change ZSH_THEME=“robbyrussell” to ZSH_THEME=“clean” #CASE_SENSITIVE=“true” to CASE_SENSITIVE=“false”

To show the machine-identification banner, add the following two lines to
`.zshrc`:

clear
neofetch

chsh -s $(which zsh)

reboot the computer

6. Automatically source ROS

echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
echo "source /opt/ros/jazzy/setup.zsh" >> ~/.zshrc

Then:

source ~/.zshrc
(if using bash - source ~/.bashrc)


printenv ROS_DISTRO

should return jazzy

ros2 --help

If you get the ROS 2 command list, we're alive.

ros2 doctor




7. Test ROS before touching Gazebo

Don't install your ROV stuff yet.

First prove that ROS itself works.

Terminal 1:

ros2 run demo_nodes_cpp talker

Terminal 2:

ros2 run demo_nodes_py listener

You should see the talker publishing and the listener receiving the messages.

That's the basic ROS 2 sanity check recommended by the ROS documentation.

Then:

ros2 topic list

You should see:

/chatter
/parameter_events
/rosout

8. Install Gazebo Harmonic

For Jazzy, Gazebo Harmonic is the pairing I'd use.

Gazebo explicitly identifies Jazzy + Harmonic as the recommended combination.

For your project, I'd actually install the ROS integration package:

sudo apt install ros-jazzy-ros-gz

reboot

That gives you the ROS ↔ Gazebo integration.

You can then check:

gz sim

You should get the Gazebo GUI.



## SSH access and GitHub repository access

SSH serves two separate purposes in this setup. Keep the keys and their roles
separate.

### Laptop to VM administration

Install the SSH server in the VM so it can be administered from the laptop
without keeping the virtual-machine display open:

```bash
sudo apt install openssh-server
```

Use an Ed25519 key for the laptop-to-VM connection. Add the laptop's
`ssh-ed25519` public key to the VM user's `~/.ssh/authorized_keys`. This is not
an `sshd_config` setting. The key lets the laptop authenticate to the VM; do
not copy a personal public key into this repository or enable password
authentication merely to make SSH work.

From the laptop, verify the connection with the VM user's address:

```bash
ssh <vm-user>@<vm-host-or-address>
```

### VM to GitHub repository access

Generate a separate Ed25519 key pair inside the VM for GitHub access:

```bash
ssh-keygen -t ed25519 -C "<vm-user>@rov-hil-sil.local"
```

Add the resulting public key (`~/.ssh/id_ed25519.pub`) to the GitHub account
that has read/write permission for the ROV repository. The private key remains
only in the VM. After adding the key, verify GitHub authentication:

```bash
ssh -T git@github.com
```

GitHub authentication alone does not grant repository write access; the GitHub
account associated with the key must also be granted that permission. Verify
the configured repository remote before making a change:

```bash
git remote -v
```




sudo apt install python3-colcon-common-extensions python3-rosdep python3-vcstool
sudo rosdep init
rosdep update


--- end ---



9. Test ROS ↔ Gazebo

This is the important test for your eventual HIL system.

You want to establish that:

ROS 2
  │
  │ ros_gz
  ▼
Gazebo

actually works before creating the ROV.

I'd then build a trivial test model:

          Gazebo
            │
       simulated IMU
            │
            ▼
         ROS 2
            │
        /imu/data
            │
            ▼
          RViz

Once that works, we know the entire simulation pipeline is functional.

10. Then create your HIL/SIL workspace

I'd keep the ROS workspace inside the HIL repository, consistent with what we discussed earlier.

we have the git repo now…

git clone git@github.com:PhilipMcGaw/ROV---HiL-and-SiL.git "$HOME/ROV - HiL and SiL"

The repository layout is:

ROV - HiL and SiL/
│
├── README.md
├── configs/          # simulator, bridge, NATS, and environment configuration
├── docs/             # maintained architecture and operating documentation
├── ros2_ws/
│   └── src/          # future ROS packages
├── scenarios/        # repeatable test scenarios and expected outcomes
├── scripts/          # build and test helpers
└── tests/            # automated and manual integration-test definitions

I would not put the ROS workspace in your home directory independently of the Git repository.

The repository describes the complete HiL/SiL environment. `ros2_ws/build`,
`ros2_ws/install`, and `ros2_ws/log` are generated output and must remain out
of version control.

11. Then bring NATS into it

This is where your architecture becomes particularly useful.

Your VM would contain:

Ubuntu VM
│
├── ROS 2
│
├── Gazebo
│
├── RViz
│
├── rov_hil_bridge
│
└── NATS client
        │
        │ TCP :4222
        ▼
   Raspberry Pi
        │
        └── NATS server

The HIL bridge becomes the boundary between the two worlds:

                     HIL VM
             ┌───────────────────┐
             │                   │
             │     Gazebo        │
             │       │           │
             │       ▼           │
             │     ROS 2         │
             │       │           │
             │       ▼           │
             │  rov_hil_bridge   │
             │       │           │
             └───────┼───────────┘
                     │
                    NATS
                     │
                     ▼
              Raspberry Pi
                     │
              NATS Server
                     │
          ┌──────────┴─────────┐
          │                    │
      ROV Control          DataLogger

That's a very clean separation.

One concern: Gazebo performance

This is the part I'd watch carefully on a 2017 MacBook Pro.

ROS itself should be fine.

Gazebo is where the VM can become painful because you're effectively doing:

macOS
  ↓
VMware
  ↓
Ubuntu
  ↓
Gazebo rendering

Fusion's 3D acceleration can use the host GPU, so I'd initially leave Accelerate 3D Graphics enabled. VMware documents this setting under the VM's Display hardware settings.

If Gazebo becomes unstable or the VM has graphical problems, it's worth testing with 3D acceleration disabled; VMware documents that as the standard troubleshooting switch.

For your ROV simulator, I wouldn't start with an elaborate underwater scene.

Start with:

simple tank
+
ROV body
+
6 thrusters
+
IMU
+
depth sensor
+
camera

Then increase complexity.

What I'd actually do on your Mac

I'd make this a clean VM, rather than modifying an existing Ubuntu VM:

VMware Fusion
└── ROV-HIL-Ubuntu
    ├── Ubuntu 24.04
    ├── ROS 2 Jazzy
    ├── Gazebo Harmonic
    ├── RViz
    ├── VS Code
    ├── Git
    └── ROV HiL/SiL workspace (~/ROV - HiL and SiL)

Then take a VM snapshot immediately after ROS + Gazebo have passed their basic tests.

That gives you a known-good baseline. If we subsequently break Gazebo, ROS dependencies, Python packages, etc., you can roll straight back rather than spending hours repairing the installation.

And I would not install NATS inside this VM as a server. The VM should be a NATS client connecting to the Raspberry Pi, as we established earlier.
