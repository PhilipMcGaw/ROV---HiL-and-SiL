# Day 0.5 — NATS Core networking

## Objective

Understand and verify the NATS Core network independently of ROS 2 and the physical robot.

## Principle

NATS is the communication layer between the application components. JetStream is not part of the system; persistence is a Datalogger responsibility.

## First configuration

Use two Ubuntu endpoints so the exercise does not depend on the physical ROV:

```text
Ubuntu endpoint A ── NATS Core ── Ubuntu endpoint B
```

A later HiL configuration may replace one endpoint with the Raspberry Pi.

## Learn

- NATS server/client roles;
- subjects and subscriptions;
- wildcards;
- publish/subscribe;
- request/reply;
- connection and reconnection behaviour;
- basic diagnostics; and
- network addressing/firewall considerations.

Do not introduce JetStream.

## Exit criteria

- [ ] A NATS Core server is reachable from another Ubuntu endpoint.
- [ ] A publisher can send a message.
- [ ] A subscriber receives it.
- [ ] Subject wildcards are understood and tested.
- [ ] Request/reply is understood and tested.
- [ ] The same network model can later be used by the RPi without changing the HiL/SiL ROS architecture.
