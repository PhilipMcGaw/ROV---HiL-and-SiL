# Day 7 — Repeatable HiL/SiL scenarios

## Objective

Turn the simulation environment into an engineering test system rather than merely a visual simulator.

## SiL

Cockpit, Control and Datalogger may be virtualised, but not inside the HiL/SiL simulation machine. They can run in separate Ubuntu boxes/VMs using the same NATS network.

```text
Cockpit ─┐
Control ─┼─ NATS network ── HiL/SiL bridge ── ROS 2 ── Gazebo
Datalogger┘
```

## HiL later

A real Raspberry Pi may participate over the same NATS network:

```text
Raspberry Pi ── NATS network ── HiL/SiL environment
```

The physical robot is not required to complete SiL development.

## Scenario definition

Each scenario defines initial conditions, command sequence, expected actuator response, expected vehicle response, expected telemetry, duration/time limits and pass/fail criteria.

Start with stationary, forward, reverse, turn and dive scenarios.

## Evidence

The scenario must produce enough data to determine whether the expected behaviour occurred. The separate Datalogger may record sensor/operational data and may eventually record relevant NATS traffic as a black-box record.

## Exit criteria

- [ ] A complete command → actuator → physics → sensor → telemetry scenario is repeatable.
- [ ] Scenario inputs and expected outputs are stored in the repository.
- [ ] Pass/fail criteria are explicit.
- [ ] The scenario runs offline without physical hardware.
- [ ] Later RPi/NATS HiL can use the same ROS/Gazebo model without architectural changes.
