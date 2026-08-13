# Day 2 — ROS 2 packages, messages, and launch

## Objective

Create a colcon workspace, build a ROS package, define ROV messages, launch nodes, and inspect the graph.

Planned messages include `ROVTelemetry` with depth, heading, temperature, and battery voltage, and `ROVMotorCommand` with left and right demands.

```bash
colcon build
source install/setup.zsh
ros2 topic list
```

Keep message definitions and units aligned with the ROV NATS contract.
