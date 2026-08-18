# ROS 2 / Gazebo Course for the ROV HiL/SiL Project

## Purpose

This is a personal engineering learning path for Philip McGaw. It is not a generic ROS 2 course. The objective is to learn only the ROS 2, Gazebo and NATS concepts required to build and verify the ROV HiL/SiL environment.

The course is deliberately build-and-prove oriented. Each day introduces one layer, establishes a working result, and states what has and has not been demonstrated.

## Architecture boundary

The HiL/SiL repository runs independently in an Ubuntu VM or dedicated Ubuntu machine. The physical ROV and Raspberry Pi controller are initially out of scope. Later, a real Raspberry Pi robot may exchange the same NATS data with the HiL/SiL environment.

Cockpit provides control. Internal application communication uses NATS Core. Camera/video is carried by the appropriate HTTP/video interface rather than NATS. Datalogger is a separate repository and is not implemented here; it records sensor/operational data and may ultimately record NATS traffic as a black-box recorder. JetStream is not part of the system.

## Course order

| Stage - Lesson | Result |
|------|---|
| [Day 1 — Workstation Setup](01-environment.md) | Known-good Ubuntu, ROS 2 Jazzy, Gazebo Harmonic, RViz2 and colcon environment |
| [Day 2 — NATS Networking](02-nats-networking.md) | Working NATS Core network without requiring the physical ROV |
| [Day 3 — Robot Description](03-robot-description.md) | Xacro → URDF → TF → RViz2 |
| [Day 4 — ROS 2 Fundamentals](04-ros2-fundamentals.md) | Nodes, topics, services, parameters, launch and QoS |
| [Day 5 — Gazebo](05-gazebo.md) | Simple model running through ROS 2/Gazebo integration |
| [Day 6 — Vehicle Model](06-vehicle-model.md) | Vehicle, thrusters and progressively more realistic motion |
| [Day 7 — Sensors and Camera](07-sensors-and-camera.md) | IMU, depth, heading and simulated camera |
| [Day 8 — NATS ↔ ROS 2 Bridge](08-nats-ros2-bridge.md) | Application contract mapped to ROS 2 without exposing ROS to Cockpit/Control |
| [Day 9 — HiL/SiL Scenarios](09-hil-sil-scenarios.md) | Repeatable integration tests and evidence |


## Exit-criteria principle

A day is complete when its practical checks pass. Reading the material is not itself evidence of a working system.

## Supporting Material

- [Architecture](docs/architecture.md)
- [VMware Fusion Setup](00-vmware-fusion.md)


Historical material has been removed from the main learning path where it duplicates the current setup.

## Dependencies

```text
Day 0 → Day 0.5 → Day 1 → Day 2 → Day 3 → Day 4 → Day 5 → Day 6 → Day 7
```

Day 0.5 is deliberately before Day 6 so NATS networking is understood independently of ROS integration.
