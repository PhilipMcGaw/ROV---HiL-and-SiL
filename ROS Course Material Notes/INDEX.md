# ROV HiL/SiL course material

This directory contains the staged training course for the independent ROV HiL/SiL environment. Complete the days in order.

## Course sequence

| Order | Guide | Outcome |
| --- | --- | --- |
| Day 0 | [Prepare the development environment](day-0-environment.md) | Establish Ubuntu, ROS 2, Gazebo, RViz2, Git, and the workspace. |
| Day 0.5 | [NATS networking](day-0-5-nats-networking.md) | Prove the network path to the Raspberry Pi NATS Core server. |
| Day 1 | [ROS 2 fundamentals](day-1-ros-fundamentals.md) | Learn nodes, topics, messages, services, actions, parameters, and launch files. |
| Day 2 | [ROS 2 packages, messages, and launch](day-2-ros-packages.md) | Build packages and establish ROV message and unit conventions. |
| Day 3 | [Gazebo](day-3-gazebo.md) | Load a simple underwater vehicle model and verify basic movement. |
| Day 4 | [Sensors and actuators](day-4-sensors-actuators.md) | Create the simulated command → actuator → motion → sensor loop. |
| Day 5 | [Cameras and the ROV environment](day-5-cameras-environment.md) | Add a useful camera and underwater environment. |
| Day 6 | [NATS and ROS 2](day-6-nats-ros2.md) | Bridge the established NATS contract to ROS 2 topics. |
| Day 7 | [HiL/SiL test scenarios](day-7-hil-sil.md) | Create repeatable integration tests and evidence. |

## Setup companions

These are supporting installation notes, not additional course days:

- [VMware Fusion workstation notes](01_VMware_fusion.md)
- [Detailed ROS 2/Gazebo installation walkthrough](02_thing.md)

Use Day 0 as the concise course entry point. The companion documents overlap and their commands must be checked against current official Ubuntu, ROS 2, and Gazebo documentation.

## Learning dependency

```text
Day 0 → Day 0.5 → Days 1–2 → Days 3–5 → Day 6 → Day 7
```

Day 0.5 deliberately precedes Day 6 so network and NATS operation are proven before ROS 2 bridge work begins.

The guides describe the intended sequence; they do not by themselves prove automated, bench, physical, or production validation.
