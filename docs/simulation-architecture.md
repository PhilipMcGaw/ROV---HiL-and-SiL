# Simulation architecture

The HiL/SiL system is an adapter around the existing ROV software, not a replacement for it.

```text
NATS command
    ↓
HiL bridge
    ↓
ROS 2 command topic
    ↓
Gazebo thruster/vehicle model
    ↓
simulated IMU, depth, heading, camera
    ↓
ROS 2 telemetry topics
    ↓
HiL bridge
    ↓
NATS telemetry
```

The bridge owns topic and message translation. It should not duplicate propulsion safety logic from Control. Payload and unit mappings must be documented before a bridge implementation is added.
