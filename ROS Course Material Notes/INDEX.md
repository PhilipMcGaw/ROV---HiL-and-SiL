I'd add NATS installation to the course

I think our revised course should now have a small Day 0.5 — NATS networking section:

Day 0
Ubuntu VM + ROS 2 + Gazebo

Day 0.5
Pi NATS server
     ↓
Mac NATS client
     ↓
Pub/sub test

Day 1
ROS 2

...

Day 6
NATS ↔ ROS 2 bridge

That way, when we get to Day 6, NATS networking is already known to work and we're only solving the ROS integration problem.

And yes: I'd make the Raspberry Pi the NATS authority. That's consistent with the Pi representing the onboard ROV computer and means the HIL PC is effectively a test client attached to the vehicle's communications bus.



Updated 7-day course
Day 0 — Prepare the development environment

I'd add this before Day 1.

2017 Intel MacBook Pro
        │
        ▼
 Ubuntu 24.04 VM
        │
        ├── ROS 2 Jazzy
        ├── Gazebo Harmonic
        ├── RViz
        └── Git

Get the VM working and verify:

ros2 --version
gz sim
rviz2

Don't involve the Raspberry Pi yet.

Goal: have a working ROS 2/Gazebo development environment.

By the end of Day 7:

                         HIL PC
┌─────────────────────────────────────────────────┐
│                                                 │
│              ROS 2 + Gazebo                     │
│                                                 │
│   ┌────────────┐     ┌────────────────────┐     │
│   │ ROV model  │────►│ Physics simulation │     │
│   └────────────┘     └─────────┬──────────┘     │
│                                │                │
│              ┌─────────────────┼────────────┐   │
│              │                 │            │   │
│             IMU             Depth        Camera │
│              │                 │            │   │
│              └─────────────────┼────────────┘   │
│                                │                │
│                         ROS 2 / NATS bridge     │
└────────────────────────────┬────────────────────┘
                             │ Ethernet
                             │
                    ┌────────▼────────┐
                    │ Raspberry Pi    │
                    │                 │
                    │ ROV Control     │
                    │ DataLogger      │
                    │ NATS            │
                    └─────────────────┘

And ideally:

Press Forward in Cockpit → Control commands motors → Gazebo moves the simulated ROV → simulated IMU/depth/heading change → Control receives telemetry → Cockpit displays the result → DataLogger records it.

Day 1 — ROS 2 Fundamentals
Objective

Understand the ROS 2 communication model without getting buried in robotics theory.

Coming from an electronics/control background, think of ROS 2 roughly as a distributed instrumentation/control bus.

The important concepts are:

ROS 2	Think of it as
Node	Process/module
Topic	Data channel
Message	Structured data packet
Publisher	Data source
Subscriber	Data consumer
Service	Request/response
Action	Long-running command
Parameter	Configuration
Launch	System startup

Start with the official ROS 2 tutorials:

ROS 2 Jazzy Tutorials -- https://docs.ros.org/en/jazzy/Tutorials.html

I'd use ROS 2 Jazzy for this project rather than jumping between distributions.

Exercise 1

Create two nodes:

publisher
    │
    │ /rov/test
    ▼
subscriber

Have the publisher send:

Hello ROV
Exercise 2

Use the command line to inspect it:

ros2 node list
ros2 topic list
ros2 topic info /rov/test
ros2 topic echo /rov/test

Then publish manually:

ros2 topic pub /rov/test std_msgs/msg/String "{data: 'Hello ROV'}"
Exercise 3

Create a simple telemetry message:

depth: 12.4
heading: 183.2
temperature: 21.7

Don't worry about custom message packages yet.

End-of-day target

You should understand:

Node → Topic → Message → Publisher/Subscriber
Day 2 — ROS 2 Packages, Messages and Launch

Now move from toy examples to something resembling an engineering project.

Learn
Workspace
Package
colcon
Launch files
Parameters
Custom messages

You'll be using:

colcon build

and:

source install/setup.bash

Create:

rov_ros/
└── src/
    └── rov_demo/
Build your first ROV message

For example:

ROVTelemetry
----------------
float32 depth
float32 heading
float32 temperature
float32 battery_voltage

Then create:

ROVMotorCommand
----------------
float32 left
float32 right

Now your ROS graph starts looking like the real system:

                 ROVTelemetry
                      ▲
                      │
              ┌───────┴───────┐
              │               │
          Simulator         Cockpit
              │
              ▼
        MotorCommand

Learn rqt_graph

This is going to become extremely useful.

You should be able to visually see:

node → topic → node
End-of-day target

You can create a ROS package, define a message, build it with colcon, launch nodes and inspect the resulting graph.

Day 3 — Gazebo

Now introduce the physics engine.

Use modern Gazebo, not Gazebo Classic.

Gazebo documentation -- https://gazebosim.org/docs/latest/getstarted/

The key concepts to learn are:

World
Model
Link
Joint
Collision
Visual
Plugin
Sensor

For you, think of the hierarchy like an engineering CAD model:

ROV
│
├── Hull
│   ├── collision
│   └── visual
│
├── Left thruster
│
├── Right thruster
│
├── IMU
│
└── Camera
Exercise

Create a simple underwater vehicle:

       ┌──────────────┐
       │              │
       │     ROV      │
       │              │
       └──────────────┘
          │        │
        Thruster  Thruster

Initially don't worry about realistic underwater physics.

Get it into Gazebo.

Then get it moving.

End-of-day target

You have a simulated vehicle in Gazebo and understand how its model is constructed.

Day 4 — Sensors and Actuators

This is where it becomes relevant to your ROV.

Add:

IMU
Gazebo
   │
   ▼
IMU sensor
   │
   ▼
ROS 2 topic

You'll see things such as:

orientation
angular velocity
linear acceleration
Depth

Create a simulated depth sensor.

Conceptually:

Z position
   ↓
depth calculation
   ↓
ROS 2 depth topic
Thrusters

This is the important feedback loop.

ROS 2
  │
  ▼
Thruster command
  │
  ▼
Gazebo
  │
  ▼
force/torque
  │
  ▼
ROV motion

Then:

ROV motion
    │
    ├──► IMU
    ├──► depth
    └──► heading
End-of-day target

You have:

motor command
     ↓
vehicle motion
     ↓
simulated sensors

working.

That is the foundation of your SIL system.

Day 5 — Cameras and the ROV Environment

Now make the simulation visually useful.

Add a Gazebo camera:

ROV
 │
 └── Camera
       │
       ▼
   Gazebo image
       │
       ▼
     ROS 2

Learn about:

camera topics
image messages
camera parameters
resolution
frame rate
field of view
camera transforms

Create a basic underwater environment.

For example:

             water
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

       rocks        obstacle
        ███           ███

              ┌─────┐
              │ ROV │
              └─────┘

Don't spend hours making it pretty.

The objective is:

Can my real Cockpit display a simulated ROV camera?

Stretch goal

Add:

lighting
seabed
obstacles
a target object

This will become useful for later autonomous navigation experiments.

Day 6 — NATS ↔ ROS 2

This is the day where the simulation becomes part of your ROV architecture.

Don't make the rest of your ROV software ROS-dependent.

Instead:

             NATS
               │
        ┌──────▼──────┐
        │ NATS ↔ ROS  │
        │   bridge    │
        └──────┬──────┘
               │
              ROS
               │
            Gazebo

For example:

NATS → ROS
rov.motor.command

becomes:

/rov/thrusters/cmd
ROS → NATS
/rov/imu

becomes:

rov.telemetry.imu

And:

/depth

becomes:

rov.telemetry.depth
The critical test

Send:

Forward 50%

from your Cockpit.

You should see:

Cockpit
   ↓
NATS
   ↓
Control
   ↓
NATS
   ↓
ROS bridge
   ↓
Gazebo
   ↓
Thrusters
   ↓
ROV moves
   ↓
IMU changes
   ↓
ROS
   ↓
NATS
   ↓
Control
   ↓
Cockpit

If you achieve that, you've proved the core architecture.

Day 7 — Turn It Into HIL/SIL

Now stop thinking of it as a Gazebo experiment.

Start treating it as your test environment.

Create:

rov-hil/
├── ros2/
│   ├── rov_description/
│   ├── rov_simulation/
│   ├── rov_sensors/
│   ├── rov_actuators/
│   └── nats_bridge/
│
├── scenarios/
│   ├── stationary/
│   ├── forward/
│   ├── reverse/
│   ├── turn/
│   └── dive/
│
├── tests/
└── configs/
Build your first automated scenario
Test: Forward

Initial conditions:

Depth = 5 m
Heading = 90°
Velocity = 0

Command:

Forward = 50%

Expected:

Left motor > 0
Right motor > 0

Then:

Velocity > 0

Then:

IMU acceleration ≠ 0

Then:

Position changes

Then verify:

Cockpit displays movement

And:

DataLogger records:
    motor command
    IMU
    depth
    timestamp

That's now a genuine integration test.

The architecture you should end the week with

I'd aim for:

                         HIL PC
┌──────────────────────────────────────────────────┐
│                                                  │
│                 ROS 2 + Gazebo                   │
│                                                  │
│       ┌───────────────┐                          │
│       │ ROV simulation│                          │
│       └───────┬───────┘                          │
│               │                                  │
│       ┌───────┼────────┬─────────┐               │
│       ▼       ▼        ▼         ▼               │
│      IMU    Depth   Thrusters   Camera           │
│       │       │        │         │               │
│       └───────┴────────┴─────────┘               │
│                       │                          │
│                 NATS/ROS bridge                  │
└───────────────────────┼──────────────────────────┘
                        │ Ethernet
                        │
             ┌──────────▼──────────┐
             │    Raspberry Pi     │
             │                     │
             │ NATS                │
             │ Control             │
             │ DataLogger          │
             └──────────┬──────────┘
                        │
                     Network
                        │
             ┌──────────▼──────────┐
             │      Cockpit        │
             └─────────────────────┘

And eventually:

                    SAME ROV SOFTWARE
                           │
                ┌──────────┴──────────┐
                │                     │
             SIL/HIL               REAL ROV
                │                     │
         ROS/Gazebo              Hardware
                │                     │
                └──────────┬──────────┘
                           │
                    same NATS API

That's the architectural property I'd protect throughout the project.

What not to learn this week

Don't get distracted by:

Nav2
SLAM
MoveIt
autonomous navigation
ROS 1
Gazebo Classic
Kubernetes
elaborate underwater hydrodynamics
realistic CAD
complex ROS lifecycle management

Those are all potentially useful later, but none is necessary to prove your HIL/SIL architecture.

Your engineering mental model

Given your electronics/EMC background, I'd approach ROS like this:

ROS 2 is the distributed software backplane; Gazebo is the virtual physical plant; NATS is the interface between the ROV application layer and the simulation environment.

Once you can make command → actuator → physics → sensor → telemetry work, you've learned the parts of ROS/Gazebo that matter most for this project.
# ROV HiL/SiL ROS Course

> A practical seven-day learning path for building the ROV software-in-the-loop and hardware-in-the-loop environment.

## Status and scope

These notes are working course material, not a release procedure. Verify package names and installation commands against the selected Ubuntu and ROS 2 release before executing them. The current ROV transport boundary is **NATS Core**; older MQTT references elsewhere in the project are historical, and NATS is the intended bridge between the application services and ROS 2/Gazebo.

> **Documentation requirement:** Documentation must always be kept up to date with implemented changes. All maintained documentation must use formal British English and be written for readers with an engineering degree or equivalent technical experience.

> **Technical notation:** Place a space between numerical values and SI unit symbols, for example `5 m`, `12 V`, and `20 °C`. Use `°` by preference when expressing angles.

## Course map

| Day | Focus | Outcome |
|---|---|---|
| 0 | Ubuntu VM, ROS 2, Gazebo, and RViz2 | A working simulation workstation |
| 0.5 | NATS networking | A verified Pi/server-to-HIL-client connection |
| 1 | ROS 2 fundamentals | Nodes, topics, messages, publishers, and subscribers |
| 2 | ROS 2 packages and launch | A buildable workspace and custom messages |
| 3 | Gazebo | A simple simulated ROV model |
| 4 | Sensors and actuators | Command-to-motion-to-sensor feedback |
| 5 | Cameras and environment | A usable underwater simulation view |
| 6 | NATS ↔ ROS 2 | A bridge between the ROV application layer and simulation |
| 7 | HIL/SIL scenarios | Repeatable integration tests |

## Related notes

- [VMware Fusion and Ubuntu setup](01_VMware_fusion.md)
- [Detailed installation walkthrough](02_thing.md)
- [Repository architecture](../MASTER_CONTEXT.md)

## End-to-end target

```text
Cockpit → NATS Core → Control → NATS Core → ROS 2/Gazebo
                                              ↓
                               simulated sensors/telemetry
                                              ↓
                              Control and Datalogger
```
