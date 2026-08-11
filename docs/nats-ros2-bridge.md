# NATS/ROS 2 bridge

The bridge translates between NATS subjects and ROS 2 topics. It owns transport and message translation, but not propulsion safety policy.

```text
NATS subject → payload adapter → ROS 2 topic
ROS 2 topic → payload adapter → NATS subject
```

The bridge must preserve units, ranges, timestamps, and failure behaviour. A lost bridge must not leave real Control outputs active; Control remains responsible for command timeouts and neutral output.
