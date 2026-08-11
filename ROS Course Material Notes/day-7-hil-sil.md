# Day 7 — Turn the work into HiL/SiL tests

## Objective

Create repeatable integration scenarios for stationary, forward, reverse, turn, and dive behaviour.

Each scenario must specify initial conditions, commands, expected actuator response, expected simulated motion, expected telemetry, and the data that Datalogger should record.

```text
Cockpit → NATS → Control → NATS/ROS 2 bridge → Gazebo
Gazebo → simulated sensors → bridge → NATS → Cockpit/Datalogger
```
