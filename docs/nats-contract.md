# NATS contract

NATS Core is the live communications layer. Use dot-separated subjects, for example:

```text
output.hbridge.left.demand
sensor.water.depth
sensor.ahrs.imu.heading
```

Payloads, units, ranges, and update rates must remain aligned with the Control and Cockpit repositories. Do not introduce JetStream for the Datalogger; it subscribes to live traffic and persists locally to SQLite/CSV.

Any subject change requires updates to Control, Cockpit, Datalogger, the bridge, and this documentation.
