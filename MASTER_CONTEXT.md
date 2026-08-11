# ROV HiL and SiL Master Context

## Purpose

This repository is the ROV simulation and integration-test environment. It will provide a software-in-the-loop (SiL) Gazebo simulation and a hardware-in-the-loop (HiL) bridge so the real Cockpit, Control, and Datalogger services can be tested without relying exclusively on the physical ROV.

HiL/SiL always runs as an independent environment: either a standalone VM or dedicated physical hardware. It is not installed into the Cockpit, Control, or Datalogger repositories and does not require their Python runtimes, virtual environments, or Windows portable-Python scripts.

## Boundary

The simulation must expose the same MQTT-facing contract as the real ROV. ROS 2, Gazebo, and the bridge are internal to this repository. Do not make Cockpit or Control depend directly on ROS 2.

```text
Cockpit ── MQTT ── Control ── MQTT ── HiL bridge ── ROS 2 ── Gazebo
                                                        │
                                      simulated sensors ┘
```

The older course notes refer to NATS. That is historical planning material; the current ROV integration boundary is MQTT unless a future architecture decision explicitly changes it.

## Intended simulation scope

- ROV hull and thruster model.
- Simulated thruster response and vehicle motion.
- IMU, depth, heading, and camera sensors.
- Repeatable scenarios for stationary, forward, reverse, turn, and dive behaviour.
- Bridge tests proving command → actuator → physics → sensor → telemetry.
- Optional hardware-in-the-loop connections to the Raspberry Pi control system.

## Repository layout

- `ros2_ws/` — colcon workspace; packages belong under `ros2_ws/src/`.
- `configs/` — MQTT, bridge, simulator, and environment configuration.
- `scenarios/` — scenario inputs and expected results.
- `tests/` — automated and manual integration-test definitions.
- `docs/` — maintained project documentation.
- `ROS Course Material Notes/` — background setup/course material; not authoritative architecture.

## Engineering rules

- Keep simulation-facing MQTT topics and payloads compatible with the real ROV services.
- Start with a simple tank, hull, thrusters, IMU, depth sensor, heading, and camera.
- Add physical realism only after the command/telemetry loop is repeatable.
- Do not use simulation success as evidence that real hardware is safe.
- Keep build output (`ros2_ws/build`, `install`, and `log`) out of version control.
- Treat the VM or dedicated HiL/SiL machine as the environment boundary; do not add application-runtime bootstrap support here.
- Document every scenario’s initial conditions, command, expected response, and telemetry checks.

## Documentation-sync rule

Changes to the ROS distribution, Gazebo version, MQTT bridge, simulated sensors, scenarios, workspace layout, or test process must update this file and the relevant documentation in the same change.
