# Scenario testing

Each scenario should define:

1. Initial vehicle state.
2. NATS command or command sequence.
3. Expected actuator response.
4. Expected simulated movement and sensor response.
5. Expected NATS telemetry.
6. Evidence to be recorded by Datalogger.

The first planned scenario is `forward`:

- Initial depth: 5 m.
- Initial heading: 90°.
- Initial velocity: 0.
- Command: forward at 50%.
- Expected: both forward thrusters respond, position changes, and IMU/depth/heading telemetry is produced.

Scenarios must be safe to repeat and must not require real propulsion power.
