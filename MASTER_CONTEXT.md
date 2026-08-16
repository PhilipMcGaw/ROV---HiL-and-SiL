# ROV HiL and SiL Master Context

## Purpose

This repository is the ROV simulation and integration-test environment. It will provide a software-in-the-loop (SiL) Gazebo simulation and a hardware-in-the-loop (HiL) bridge so the real Cockpit, Control, and Datalogger services can be tested without relying exclusively on the physical ROV.

HiL/SiL always runs as an independent environment: either a standalone VM or dedicated physical hardware. It is not installed into the Cockpit, Control, or Datalogger repositories and does not require their Python runtimes, virtual environments, or Windows portable-Python scripts.

## Boundary

The documented default clone location on the standalone Linux VM or dedicated Linux machine is `~/ROV - HiL and SiL`, beside `~/ROV - Cockpit`, `~/ROV - Control`, and `~/ROV - Datalogger` when those repositories are present. On macOS, use a user-selected workspace beneath the home directory, for example `~/Projects/ROV/ROV - HiL and SiL`. This is a convention for documentation and operator setup, not a hard-coded runtime requirement.

The simulation must expose the same NATS-facing contract as the real ROV. ROS 2, Gazebo, and the bridge are internal to this repository. Do not make Cockpit or Control depend directly on ROS 2.

```text
Cockpit ── NATS Core ── Control ── NATS Core ── HiL bridge ── ROS 2 ── Gazebo
                                                        │
                                      simulated sensors ┘
```

Older project documents refer to MQTT. That is historical migration material; the current ROV integration boundary is NATS Core.

## Intended simulation scope

- ROV hull and thruster model.
- Simulated thruster response and vehicle motion.
- IMU, depth, heading, and camera sensors.
- Repeatable scenarios for stationary, forward, reverse, turn, and dive behaviour.
- Bridge tests proving command → actuator → physics → sensor → telemetry.
- Optional hardware-in-the-loop connections to the Raspberry Pi control system.

## Repository layout

- `ros2_ws/` — colcon workspace; packages belong under `ros2_ws/src/`.
- `configs/` — NATS, bridge, simulator, and environment configuration.
- `scenarios/` — scenario inputs and expected results.
- `tests/` — automated and manual integration-test definitions.
- `docs/` — maintained project documentation.
- `ROS Course Material Notes/` — background setup/course material; not authoritative architecture.

The authoritative training order is `ROS Course Material Notes/INDEX.md`: Day 0 environment, Day 0.5 NATS networking, Days 1–2 ROS 2 foundations, Days 3–5 simulation and sensors, Day 6 NATS/ROS 2 bridge, and Day 7 repeatable HiL/SiL scenarios. `01_VMware_fusion.md` and `02_thing.md` are setup companions rather than additional course days.

Supporting course topics are maintained in `docs/`: ROS 2 QoS and time, TF2 frames, URDF/Xacro modelling, sensor fidelity, safety boundaries, logging and replay, automated scenario testing, NATS diagnostics, camera integration, and performance/simulation time. Linux and Git foundations are assumed knowledge and are intentionally not course topics.

The HiL/SiL workstation must use a ROS-supported Ubuntu pairing rather than the newest Ubuntu LTS by default. The current course target is Ubuntu 24.04 LTS AMD64 with ROS 2 Jazzy and Gazebo Harmonic; changing it requires verification of the complete ROS, Gazebo, `ros_gz`, RViz2, and package-support combination.

## Engineering rules

- Keep simulation-facing NATS subjects and payloads compatible with the real ROV services.
- Start with a simple tank, hull, thrusters, IMU, depth sensor, heading, and camera.
- Add physical realism only after the command/telemetry loop is repeatable.
- Do not use simulation success as evidence that real hardware is safe.
- Keep build output (`ros2_ws/build`, `install`, and `log`) out of version control.
- Treat the VM or dedicated HiL/SiL machine as the environment boundary; do not add application-runtime bootstrap support here.
- Document every scenario’s initial conditions, command, expected response, and telemetry checks.

## Documentation-sync rule

The enforceable policy is `docs/documentation-policy.md`; contributor guidance is `CONTRIBUTING.md`; current status is `docs/status.md`; and the standard-library checks are `tests/test_documentation.py` and `tests/documentation_change_policy.py`, using `tests/documentation_change_policy.json` for path rules and intentional exemptions.

Changes to the ROS distribution, Gazebo version, NATS bridge, simulated sensors, scenarios, workspace layout, or test process must update this file and the relevant documentation in the same change. Every change must include a consistency check of this file; if it is not a true reflection of current behaviour, correct it in the same change. Documentation must remain current, use formal British English, and be written for readers with an engineering degree or equivalent technical experience.

Where SI units are used, place a space between the numerical value and the unit symbol, for example `5 m`, `12 V`, and `20 °C`. Use the degree symbol `°` by preference for angles.

Where this repository uses POSIX shell scripts, they must follow the same verbose diagnostic, strict-error, portable-path, prerequisite-validation, and no-unapproved-system-change standards as the ROV application repositories.

Where emails and names are needed, like in <maintainer email="philip@mcgaw.eu">Philip McGaw</maintainer>

Name is Philip McGaw
email is philip@mcgaw.eu
website is https://philipmcgaw.com
