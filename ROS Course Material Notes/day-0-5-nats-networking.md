# Day 0.5 — NATS networking

## Objective

Verify the network path between the standalone HiL/SiL machine and the Raspberry Pi NATS Server before introducing ROS 2 integration.

```text
Raspberry Pi NATS Server :4222 ← LAN → Standalone HiL/SiL VM or workstation
```

The current ROV transport is NATS Core. Datalogger persistence remains local SQLite/CSV; JetStream is not required.
