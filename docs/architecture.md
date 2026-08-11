# HiL/SiL architecture

The HiL/SiL environment is an independent VM or dedicated machine. It contains ROS 2, Gazebo, RViz2, the simulation packages, and the NATS/ROS 2 bridge.

```text
Cockpit ── NATS Core ── Control ── NATS Core ── HiL bridge ── ROS 2 ── Gazebo
  ▲                                                        │
  └────────────── NATS telemetry ── Datalogger ◄──────────┘
```

Cockpit and Control must not become ROS-dependent. The bridge adapts the application contract to ROS 2 topics.
