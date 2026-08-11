# Sensor models

The initial simulated sensor set is:

- IMU: orientation, angular velocity, and acceleration.
- Depth: vehicle depth relative to the water surface.
- Heading: vehicle yaw in the agreed coordinate convention.
- Camera: image stream suitable for Cockpit display.

Each sensor must document its frame, units, update rate, noise model, and NATS/ROS 2 mapping.
