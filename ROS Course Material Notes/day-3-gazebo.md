# Day 3 — Gazebo fundamentals

## Objective

Introduce Gazebo Harmonic and the ROS 2/Gazebo integration without yet introducing underwater physics or the NATS application bridge.

Reuse the simple robot from Day 1 where practical. This isolates Gazebo integration from ROV complexity.

```text
Xacro / URDF
    ↓
ROS 2
    ↓
ros_gz
    ↓
Gazebo
```

## Exercises

1. Start Gazebo reliably.
2. Spawn the simple robot.
3. Inspect visual and collision geometry.
4. Confirm the ROS 2/Gazebo connection.
5. Introduce simulation time and understand `/clock` and `use_sim_time`.
6. Establish a repeatable launch procedure.

Do not introduce realistic hydrodynamics, NATS, Cockpit, Control or hardware yet.

## Exit criteria

- [ ] Gazebo starts reliably.
- [ ] The model spawns.
- [ ] ROS 2 and Gazebo exchange the required data.
- [ ] Simulation time is understood and works for relevant nodes.
- [ ] The launch sequence is repeatable.
