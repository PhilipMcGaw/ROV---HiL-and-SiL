# Day 5 — Sensors and camera

## Objective

Add the sensor and camera outputs required to make the simulated vehicle useful to the application layer.

## Sensors

Begin with IMU, depth, heading and relevant telemetry.

```text
vehicle state
    ↓
sensor model
    ↓
ROS 2 data
    ↓
telemetry
```

Start with ideal values. Progressively introduce noise, bias, latency, update rate, quantisation and dropouts where they improve test value.

## Camera

For the real ROV, the camera comes from one or more real video feeds. For offline SiL, the camera is simulated in Gazebo.

The camera/video path is separate from NATS:

```text
Gazebo camera ── HTTP/video interface ──→ Cockpit
```

Cockpit should receive simulated camera output through the same application-facing video interface intended for the real system.

## Exit criteria

- [ ] IMU data is available.
- [ ] Depth data is available.
- [ ] Heading data is available.
- [ ] Sensor timestamps use the correct simulation-time model.
- [ ] A simulated camera produces a usable stream.
- [ ] Camera transport remains separate from NATS application messaging.
