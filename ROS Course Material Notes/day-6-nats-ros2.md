# Day 6 — NATS and ROS 2

## Objective

Implement the bridge between the application-facing NATS subjects and internal ROS 2 topics.

```text
NATS command → bridge → ROS 2 → Gazebo
Gazebo → ROS 2 → bridge → NATS telemetry
```

The bridge must preserve subject names, payload formats, units, safety boundaries, and timing expectations. Cockpit and Control must not become ROS-dependent.
