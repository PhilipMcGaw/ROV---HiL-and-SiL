# Sensor fidelity, rates, units, and noise

Every simulated sensor must document its unit, update rate, timestamp source, frame, nominal range, saturation behaviour, missing-data behaviour, and noise model.

Start with deterministic values for integration tests. Add bounded noise and latency only when the deterministic command-to-telemetry path is passing. Keep the distinction between simulated data, bench measurements, and production sensor data explicit.

Scenario assertions must allow for the documented rate, latency, precision, and noise. They must not silently convert units or accept stale data.

Relevant course stages: Day 4 for IMU, depth, and heading sensors; Day 5 for camera output; Day 6 for bridge payload conversion.
