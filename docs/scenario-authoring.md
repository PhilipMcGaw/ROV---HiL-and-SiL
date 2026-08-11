# Scenario authoring

Every scenario must define:

1. Initial vehicle state.
2. Command sequence.
3. Expected actuator response.
4. Expected vehicle motion.
5. Expected sensor telemetry.
6. Expected Datalogger records.

Use the existing folders under `scenarios/` for stationary, forward, reverse, turn, and dive cases. Scenarios must be repeatable and must not require real propulsion power.
