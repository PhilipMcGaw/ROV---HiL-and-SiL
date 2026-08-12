# Camera integration validation

Validate the simulated camera independently from the vehicle physics. Record camera frame, resolution, frame rate, transport path, fallback behaviour, and the Cockpit endpoint or bridge interface used for display.

First confirm that Gazebo produces a stable image. Then confirm that the approved bridge or transport exposes it to the Cockpit without changing the NATS command and telemetry contract.

Camera display success is an integration result, not proof that the physical camera, lighting, optics, or production media path has been validated.

Relevant course stages: Day 5 for camera creation and Day 7 for end-to-end display evidence.
