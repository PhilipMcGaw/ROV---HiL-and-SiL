# Day 6 — NATS ↔ ROS 2 bridge

## Objective

Add the application integration boundary only after the ROS 2/Gazebo system works independently.

```text
NATS application contract
          ↕
    NATS ↔ ROS 2 bridge
          ↕
       ROS 2 graph
          ↕
        Gazebo
```

The bridge is an adapter. It does not contain vehicle physics, Cockpit logic or Control logic.

## Command path

```text
Cockpit / Control → NATS → bridge → ROS 2 → Gazebo
```

## Telemetry path

```text
Gazebo → ROS 2 → bridge → NATS → Cockpit / Datalogger
```

Preserve established NATS subjects, payload formats, units, safety boundaries and timing expectations. Do not make Cockpit or Control depend directly on ROS 2. Do not introduce JetStream.

## Exit criteria

- [ ] NATS commands reach the bridge.
- [ ] The bridge produces the correct ROS 2 commands.
- [ ] Gazebo responds.
- [ ] Simulated telemetry returns through the bridge.
- [ ] Cockpit-facing application data remains NATS-based.
- [ ] ROS 2 remains an internal HiL/SiL implementation detail.
