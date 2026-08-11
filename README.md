# ROV HiL and SiL

Simulation and integration-test environment for the ROV project.

This repository will contain the ROS 2/Gazebo software-in-the-loop environment and the hardware-in-the-loop bridge used to test the same Cockpit and Control interfaces before connecting real hardware. It always runs independently in its own virtual machine or on dedicated physical hardware.

It does not share or require the Python runtimes, virtual environments, or Windows portable-Python support used by the Cockpit, Control, and Datalogger repositories.

## Planned architecture

```text
Cockpit ── MQTT ── Control ── MQTT ── HiL bridge ── ROS 2 ── Gazebo
                                      ▲                 │
                                      └── telemetry ────┘
```

The simulation must remain behind the same application-facing MQTT contract as the real ROV. ROS 2 and Gazebo are implementation details of the simulation environment.

## Repository layout

- `ros2_ws/` — future colcon workspace and ROS packages.
- `configs/` — simulator and bridge configuration.
- `scenarios/` — repeatable test scenarios and expected outcomes.
- `tests/` — integration and scenario tests.
- `docs/` — environment and simulation documentation.
- `ROS Course Material Notes/` — retained learning and setup notes.

## Current status

The repository is scaffolded, but no ROS packages or Gazebo model have been implemented yet. See [MASTER_CONTEXT.md](MASTER_CONTEXT.md) and [docs/README.md](docs/README.md).
