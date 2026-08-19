# Exercise — Build and inspect a small ROS 2 robot

## Purpose

This exercise creates a deliberately simple two-wheel robot and displays it in
RViz2.

It is a learning exercise, not an ROV implementation and not a Gazebo or
hardware validation result.

The exercise proves the first part of the simulation toolchain:

```text
Xacro
  │
  ▼
URDF robot description
  │
  ▼
robot_state_publisher
  │
  ▼
TF
  │
  ▼
RViz2
```

It gives the learner a small, controllable model for understanding links,
joints, transforms, packages, builds, launch files, and visual inspection
before adding an underwater vehicle, simulated physics, NATS, or real
hardware.

---

## Learning outcomes

By the end, you should be able to:

- create a ROS 2 package in the HiL/SiL workspace;
- describe a chassis and two wheels with Xacro and URDF;
- validate the generated URDF;
- build and source a colcon workspace;
- launch `robot_state_publisher` and `joint_state_publisher_gui`;
- inspect the robot and its transform tree in RViz2;
- understand the relationship between joint states and TF; and
- explain why this is only a model-description milestone, not a moving Gazebo
  vehicle.

---

## Scope and safety boundary

Use the independent Ubuntu HiL/SiL workstation.

Do not connect the Raspberry Pi, NATS Core, motor controllers, propulsion
hardware, or any physical ROV hardware for this exercise.

Nothing in this exercise sends a command outside the local ROS 2 graph.

This exercise does not test:

- the physical ROV;
- Raspberry Pi software;
- NATS;
- Gazebo physics;
- motor control;
- propulsion;
- sensors;
- cameras; or
- hardware-in-the-loop operation.

The workspace path is:

```text
~/ROV - HiL-and-SiL/ros2_ws
```

Because the repository name contains spaces, shell commands use:

```zsh
"$HOME/ROV - HiL-and-SiL/..."
```

Keep the quotation marks.

### Shell note

This exercise assumes ZSH.

Use `setup.zsh` when sourcing ROS or the workspace overlay.

Use the Zsh setup files consistently for the system installation and workspace overlay.

---

## Prerequisites

Complete Day 0 first.

The Ubuntu VM should have:

- Ubuntu 24.04 LTS AMD64;
- ROS 2 Jazzy;
- RViz2;
- colcon; and
- the ROS environment available.

Check the base installation in a new terminal:

```zsh
source /opt/ros/jazzy/setup.zsh
printenv ROS_DISTRO
ros2 --help
rviz2
```

`printenv ROS_DISTRO` should report:

```text
jazzy
```

RViz2 should open.

Close RViz2 before continuing.

### Install the packages used by this exercise

Install the required packages if they are not already present:

```zsh
sudo apt update
sudo apt install \
  ros-jazzy-xacro \
  ros-jazzy-robot-state-publisher \
  ros-jazzy-joint-state-publisher-gui \
  ros-jazzy-launch \
  ros-jazzy-launch-ros \
  ros-jazzy-rviz2 \
  ros-jazzy-ament-index-python \
  python3-colcon-common-extensions
```

`ament_index_python` is used by the launch file to locate installed package
resources without depending on the current terminal directory.

---

# 1. Create the workspace and package

Create the workspace if necessary, source Jazzy, and create an `ament_cmake`
package.

### Package name

The package name for this exercise is:

```text
small_robot_description
```

Do not run the package-creation command again if the package already exists.

Run these commands from the **workspace root**:

```zsh
mkdir -p "$HOME/ROV - HiL-and-SiL/ros2_ws/src"
cd "$HOME/ROV - HiL-and-SiL/ros2_ws/src"
source /opt/ros/jazzy/setup.zsh

ros2 pkg create \
  small_robot_description \
  --build-type ament_cmake \
  --dependencies robot_state_publisher xacro ament_index_python launch launch_ros
```

After that, for colcon, return to the workspace root:
```text
cd "$HOME/ROV - HiL-and-SiL/ros2_ws"
colcon list
```

The package is created under:

```text
ros2_ws/
└── src/
    └── small_robot_description/
        ├── CMakeLists.txt
        ├── package.xml
        └── src/
```




The package-level `src/` directory is not required for this exercise because
the package contains no C++ or Python nodes.

Create directories for the robot description and launch file:

```zsh
cd "$HOME/ROV - HiL-and-SiL/ros2_ws/src/small_robot_description"
mkdir -p launch urdf
```

The package should now look like:

```text
small_robot_description/
├── CMakeLists.txt
├── package.xml
├── launch/
└── urdf/
```

Do not create or build an `install/` directory inside `src/`.

The normal colcon workspace layout is:

```text
ros2_ws/
├── build/
├── install/
├── log/
└── src/
    └── small_robot_description/
```

### Important: colcon working directory

Always run `colcon build` from the **workspace root**:

```text
Correct:
~/ROV - HiL-and-SiL/ros2_ws

Incorrect:
~/ROV - HiL-and-SiL/ros2_ws/src
```

Colcon creates `build/`, `install/` and `log/` alongside `src/`.

Check that colcon can see the package before continuing:

```zsh
cd "$HOME/ROV - HiL-and-SiL/ros2_ws"
colcon list
```

Expected result:

```text
small_robot_description    src/small_robot_description    (ros.ament_cmake)
```

If `colcon list` returns no packages, stop here and correct the package
location before building.

---

# 2. Describe the robot

Create:

```text
urdf/small_robot.urdf.xacro
```

with the following contents.

The dimensions are in metres and mass is in kilograms.

The inertia entries are deliberately simple placeholders. They are adequate
for visualisation only; do not reuse them for Gazebo physics without a proper
mass-property calculation.

```xml
<?xml version="1.0"?>
<robot xmlns:xacro="http://www.ros.org/wiki/xacro" name="small_robot">

  <xacro:property name="body_length" value="0.40"/>
  <xacro:property name="body_width" value="0.30"/>
  <xacro:property name="body_height" value="0.12"/>
  <xacro:property name="wheel_radius" value="0.08"/>
  <xacro:property name="wheel_width" value="0.04"/>
  <xacro:property name="wheel_separation" value="0.34"/>

  <link name="base_link">
    <visual>
      <origin xyz="0 0 ${wheel_radius}"/>
      <geometry>
        <box size="${body_length} ${body_width} ${body_height}"/>
      </geometry>
      <material name="blue">
        <color rgba="0.1 0.3 0.8 1.0"/>
      </material>
    </visual>

    <collision>
      <origin xyz="0 0 ${wheel_radius}"/>
      <geometry>
        <box size="${body_length} ${body_width} ${body_height}"/>
      </geometry>
    </collision>

    <!-- Placeholder mass properties: visualisation only. -->
    <inertial>
      <mass value="5.0"/>
      <inertia ixx="0.05" ixy="0.0" ixz="0.0"
               iyy="0.08" iyz="0.0" izz="0.10"/>
    </inertial>
  </link>

  <xacro:macro name="wheel" params="name y_position">

    <link name="${name}">
      <visual>
        <origin rpy="${pi/2} 0 0"/>
        <geometry>
          <cylinder radius="${wheel_radius}" length="${wheel_width}"/>
        </geometry>
        <material name="black">
          <color rgba="0.05 0.05 0.05 1.0"/>
        </material>
      </visual>

      <collision>
        <origin rpy="${pi/2} 0 0"/>
        <geometry>
          <cylinder radius="${wheel_radius}" length="${wheel_width}"/>
        </geometry>
      </collision>

      <!-- Placeholder mass properties: visualisation only. -->
      <inertial>
        <mass value="0.5"/>
        <inertia ixx="0.002" ixy="0.0" ixz="0.0"
                 iyy="0.001" iyz="0.0" izz="0.002"/>
      </inertial>
    </link>

    <joint name="${name}_joint" type="continuous">
      <parent link="base_link"/>
      <child link="${name}"/>
      <origin xyz="0 ${y_position} 0"/>
      <axis xyz="0 1 0"/>
    </joint>

  </xacro:macro>

  <xacro:wheel name="left_wheel" y_position="${wheel_separation / 2}"/>
  <xacro:wheel name="right_wheel" y_position="${-wheel_separation / 2}"/>

</robot>
```

The robot uses the standard ROS coordinate convention:

- `x` — forward;
- `y` — left;
- `z` — up.

`base_link` is the root frame.

The continuous wheel joints let RViz animate the wheels without imposing
position limits.

The chassis visual and collision geometry is offset by `wheel_radius` in `z`.
This places the chassis above the wheel axle for this simple visual model.

---

# 3. Understand the robot description

Before continuing, inspect the structure of the Xacro file.

The robot contains:

```text
small_robot
│
├── base_link
│
├── left_wheel
│   └── left_wheel_joint
│
└── right_wheel
    └── right_wheel_joint
```

The links describe physical parts of the robot.

The joints describe how those links are connected.

The resulting relationship is:

```text
base_link
   │
   ├── left_wheel
   │
   └── right_wheel
```

The wheel joints rotate about the `y` axis:

```xml
<axis xyz="0 1 0"/>
```

At this stage, the model is only a robot description.

It does not contain:

- propulsion;
- motor controllers;
- dynamics;
- gravity;
- buoyancy;
- friction;
- thruster characteristics;
- sensor models; or
- NATS interfaces.

---

# 4. Validate the Xacro before building

Generate a URDF in `/tmp` and inspect it.

This catches malformed XML and Xacro expressions before a launch failure
obscures the cause.

```zsh
cd "$HOME/ROV - HiL-and-SiL/ros2_ws"
source /opt/ros/jazzy/setup.zsh

ros2 run xacro xacro \
  src/small_robot_description/urdf/small_robot.urdf.xacro \
  > /tmp/small_robot.urdf

head -n 20 /tmp/small_robot.urdf
```

Expected result:

- the command exits successfully; and
- `/tmp/small_robot.urdf` contains a `<robot name="small_robot">` element.

If Xacro reports an error, correct the source file before continuing.

Do not continue to the build step with an invalid generated URDF.

### Important distinction

The URDF generated in `/tmp` is a **validation artefact**.

The normal ROS 2 launch process will generate the robot description from the
Xacro file when the launch file starts.

The repository therefore keeps the Xacro source as the authoritative robot
description rather than maintaining a manually edited generated URDF.

---

# 5. Configure and install the package resources

Replace `CMakeLists.txt` with:

```cmake
cmake_minimum_required(VERSION 3.8)
project(small_robot_description)

find_package(ament_cmake REQUIRED)

install(
  DIRECTORY
    launch
    urdf
  DESTINATION share/${PROJECT_NAME}
)

ament_package()
```

The `install()` command is essential.

Without it, `ros2 launch` cannot find the launch file and Xacro after the
package is built.

---

## Configure `package.xml`

Make sure `package.xml` contains the following runtime dependencies inside
`<package>`, before the `<export>` section:

```xml
<exec_depend>ament_index_python</exec_depend>
<exec_depend>launch</exec_depend>
<exec_depend>launch_ros</exec_depend>
<exec_depend>robot_state_publisher</exec_depend>
<exec_depend>joint_state_publisher_gui</exec_depend>
<exec_depend>xacro</exec_depend>
```

Keep the existing `ament_cmake` build-tool dependency and the package metadata
generated by `ros2 pkg create`.

The resulting package name must be `small_robot_description` throughout:

- `package.xml`:
  `<name>small_robot_description</name>`
- `CMakeLists.txt`:
  `project(small_robot_description)`
- launch file package lookup;
- `colcon build --packages-select small_robot_description`;
- `ros2 launch small_robot_description display.launch.py`.

---

# 6. Add a portable launch file

Create:

```text
launch/display.launch.py
```

with the following contents:

```python
from pathlib import Path

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.substitutions import Command
from launch_ros.actions import Node
from launch_ros.parameter_descriptions import ParameterValue


def generate_launch_description():
    package_share = Path(
        get_package_share_directory("small_robot_description")
    )
    xacro_file = package_share / "urdf" / "small_robot.urdf.xacro"

    robot_description = ParameterValue(
        Command(["xacro", str(xacro_file)]),
        value_type=str,
    )

    return LaunchDescription([
        Node(
            package="robot_state_publisher",
            executable="robot_state_publisher",
            name="robot_state_publisher",
            output="screen",
            parameters=[
                {"robot_description": robot_description}
            ],
        ),
        Node(
            package="joint_state_publisher_gui",
            executable="joint_state_publisher_gui",
            name="joint_state_publisher_gui",
            output="screen",
        ),
    ])
```

The launch file uses the installed package share directory rather than a path
relative to the current terminal directory.

This means the launch file can be started from any directory after the
workspace has been built and sourced.

The function:

```python
generate_launch_description()
```

is required by ROS 2.

If it is missing or renamed, `ros2 launch` will reject the Python launch file.

---

# 7. Build and launch the robot

Build only this package on the first run.

Run colcon from the **workspace root**, not from `src/`.

```zsh
cd "$HOME/robots/ROV---HiL-and-SiL/ros2_ws"
source /opt/ros/jazzy/setup.zsh

colcon list

colcon build --packages-select small_robot_description

source install/setup.zsh

ros2 launch small_robot_description display.launch.py
```

Leave that terminal running.

A small joint-state publisher window should open.

Moving either slider changes a wheel's angle.

This is the intended input for the next inspection step.

---

# 8. Inspect the robot in RViz2

Open a second terminal:

```zsh
source /opt/ros/jazzy/setup.zsh
source "$HOME/robots/ROV---HiL-and-SiL/ros2_ws/install/setup.zsh"

rviz2
```

In RViz2:

1. Set **Fixed Frame** to `base_link`.
2. Click **Add** and choose **RobotModel**.
3. For **Description Source**, select **Topic** if it is not selected
   automatically.
4. Select `/robot_description` if required.
5. Click **Add** and choose **TF**.
6. Move the sliders in the joint-state publisher window.

Expected result:

- a blue rectangular chassis appears;
- two black wheels appear;
- the TF display shows `base_link`, `left_wheel` and `right_wheel`; and
- turning a slider rotates the corresponding wheel.

### What is actually happening?

The slider is not directly controlling RViz.

The data flow is:

```text
joint_state_publisher_gui
          │
          │ /joint_states
          ▼
robot_state_publisher
          │
          │ TF
          ▼
         RViz2
```

`joint_state_publisher_gui` publishes the selected joint positions.

`robot_state_publisher` uses the robot description and those joint positions to
calculate the transforms between the links.

RViz2 visualises those transforms and the robot model.

RViz2 is therefore **not the component calculating the robot's transforms**.

---

# 9. Verify the ROS 2 graph

Open a third terminal with both environments sourced:

```zsh
source /opt/ros/jazzy/setup.zsh
source "$HOME/robots/ROV---HiL-and-SiL/ros2_ws/install/setup.zsh"
```

Run:

```zsh
ros2 node list
```

Expected nodes include:

```text
/robot_state_publisher
/joint_state_publisher_gui
```

List the active topics:

```zsh
ros2 topic list
```

Expected topics include:

```text
/joint_states
/tf
/tf_static
```

Now inspect a transform directly:

```zsh
ros2 run tf2_ros tf2_echo base_link left_wheel
```

The command should show a transform from `base_link` to `left_wheel`.

Move the left-wheel slider.

The transform should update as the wheel position changes.

This demonstrates that the transform exists in the ROS 2 graph independently
of RViz2.

---

# 10. Inspect the generated URDF

The Xacro source can also be expanded and inspected directly.

Run:

```zsh
source /opt/ros/jazzy/setup.zsh

ros2 run xacro xacro \
  "$HOME/robots/ROV---HiL-and-SiL/ros2_ws/src/small_robot_description/urdf/small_robot.urdf.xacro" \
  > /tmp/small_robot.urdf
```

Inspect the generated robot:

```zsh
grep '<link ' /tmp/small_robot.urdf
```

Expected result should include:

```text
<link name="base_link">
<link name="left_wheel">
<link name="right_wheel">
```

Inspect the joints:

```zsh
grep '<joint ' /tmp/small_robot.urdf
```

Expected result should include:

```text
<joint name="left_wheel_joint" type="continuous">
<joint name="right_wheel_joint" type="continuous">
```

This provides a useful distinction between:

```text
Xacro source
    ↓
generated URDF
    ↓
ROS 2 robot description
```

---

# 11. Stop the exercise

When the inspection is complete:

1. Stop the launch file with `Ctrl+C`.
2. Close the joint-state publisher GUI.
3. Close RViz2.

There is no need to stop or modify any system-level ROS installation.

---

# 12. What this exercise has proved

This exercise proves that the Ubuntu HiL/SiL environment can:

- create a ROS 2 package;
- process Xacro;
- generate a valid URDF;
- install ROS package resources;
- build a colcon workspace;
- source a ROS 2 workspace overlay;
- launch ROS 2 nodes;
- publish joint states;
- calculate TF transforms; and
- visualise a robot model in RViz2.

The basic toolchain is therefore:

```text
Xacro
  ↓
URDF
  ↓
robot_state_publisher
  ↓
TF
  ↓
RViz2
```

---

# 13. What this exercise has not proved

This exercise has **not** proved:

- that Gazebo starts or renders correctly;
- that a robot has valid collision behaviour;
- that gravity works correctly;
- that propulsion works;
- that friction or traction is realistic;
- that buoyancy works;
- that a robot has realistic dynamics;
- that `/cmd_vel` makes a robot move;
- that a thruster model is valid;
- that an IMU behaves realistically;
- that a depth sensor behaves realistically;
- that a camera works;
- that NATS works;
- that the NATS/ROS 2 bridge works;
- that Cockpit works;
- that Control works;
- that the Datalogger works; or
- that any physical hardware is safe.

In particular:

```text
URDF/Xacro ≠ Gazebo simulation
```

A correct visual model is only the robot-description stage of the simulation
toolchain.

---

# 14. Why the model is not yet suitable for physics

The model contains mass and inertia values, but those values are deliberately
simplified placeholders.

They are sufficient for this visualisation exercise.

They should **not** be interpreted as physically valid mass properties.

Before the model is used for meaningful Gazebo dynamics, the vehicle model will
eventually need physically justified values for quantities such as:

- mass;
- centre of mass;
- moments of inertia;
- collision geometry;
- buoyancy;
- centre of buoyancy;
- drag;
- thruster characteristics;
- actuator response; and
- other relevant environmental effects.

This follows the project principle:

> Start with simple, repeatable physics and increase physical realism
> progressively.

---

# 15. Next milestone

The next exercise should introduce **Gazebo Harmonic** and the supported ROS 2
Gazebo integration, using `ros_gz` where appropriate.

The next milestone should first prove:

```text
Xacro
  ↓
ROS 2
  ↓
ros_gz
  ↓
Gazebo
  ↓
Robot model
```

The initial Gazebo exercise should concentrate on:

- starting Gazebo reliably;
- spawning the vehicle;
- inspecting the model;
- confirming the ROS 2/Gazebo connection; and
- establishing a repeatable launch process.

Do not introduce NATS, Cockpit, Control, Datalogger, realistic vehicle physics
or hardware integration until the basic Gazebo simulation is reliable.

---

# 16. Troubleshooting

| Symptom | Likely cause | Check or correction |
| --- | --- | --- |
| `ros2: command not found` | Jazzy is not sourced. | Run `source /opt/ros/jazzy/setup.zsh`. |
| `colcon list` returns no packages | The package is not under `ros2_ws/src/`, or colcon was run from the wrong directory. | Run `cd "$HOME/robots/ROV---HiL-and-SiL/ros2_ws"` and check the package location. |
| `Package 'small_robot_description' not found` | The package was not built or the overlay is not sourced. | Run `colcon build --packages-select small_robot_description`, then `source install/setup.zsh`. |
| `xacro: command not found` | The Xacro package is missing. | Install `ros-jazzy-xacro`. |
| `ros2 launch` cannot find the launch file | `launch/` and `urdf/` were not installed. | Check `CMakeLists.txt`, rebuild, and source the overlay again. |
| `InvalidPythonLaunchFileError` mentioning `generate_launch_description()` | The Python launch file does not contain the required function. | Check `display.launch.py` and ensure the function is named exactly `generate_launch_description()`. |
| No model appears in RViz2 | The fixed frame or robot description source is wrong. | Set Fixed Frame to `base_link`; add RobotModel and select `/robot_description`. |
| Wheel sliders do not change the view | `joint_state_publisher_gui` is not running or TF is hidden. | Check `ros2 node list`, add the TF display, and restart the launch file. |
| Build errors refer to an old description | Colcon is using stale output. | Correct the source, clean the package output if necessary, rebuild, and source the overlay in each terminal. |
| An `install/` directory exists inside `src/` | Colcon was accidentally run from `src/`. | Remove the accidental directory and always run colcon from `ros2_ws/`. |

---

# 17. Clean-build recovery

If the workspace has become confused by an earlier package layout or stale
build output:

```zsh
cd "$HOME/robots/ROV---HiL-and-SiL/ros2_ws"

rm -rf build install log

colcon build --packages-select small_robot_description

source install/setup.zsh
```

If an accidental `src/install` directory was created, remove only that
accidental directory:

```zsh
rm -rf "$HOME/robots/ROV---HiL-and-SiL/ros2_ws/src/install"
```

Then return to the workspace root and rebuild:

```zsh
cd "$HOME/robots/ROV---HiL-and-SiL/ros2_ws"

colcon build --packages-select small_robot_description

source install/setup.zsh
```

Do not delete `/opt/ros/jazzy`.

That is the system ROS installation and is separate from the workspace overlay.

---

# 18. Extension questions

Before moving on, answer these in your own words:

1. Which file contains the authoritative shape and joint relationship of the
   robot?
2. What does Xacro provide that plain URDF does not?
3. What is the difference between a link and a joint?
4. Which node publishes the robot's TF transforms?
5. What does `joint_state_publisher_gui` actually publish?
6. Why does moving a slider change the robot in RViz2?
7. Why is RViz2 not responsible for calculating the robot's transforms?
8. Why must `colcon build` be run from `ros2_ws/` rather than `ros2_ws/src/`?
9. Why are `build/`, `install/` and `log/` outside the package directory?
10. Why is a correct visual model insufficient evidence for a working simulator?
11. Which quantities would need physically justified values before this model
    could be used for meaningful Gazebo physics?
12. What additional components are required to turn this robot description into
    a simulated vehicle?
13. Why should NATS remain outside this exercise?
14. Why should the future NATS/ROS 2 bridge not make Cockpit or Control directly
    dependent on ROS 2?
