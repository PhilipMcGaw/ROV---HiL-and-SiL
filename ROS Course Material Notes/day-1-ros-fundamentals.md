# Day 1 — ROS 2 fundamentals

## Objective

Understand nodes, topics, messages, publishers, subscribers, services, actions, parameters, and launch files.

```bash
ros2 node list
ros2 topic list
ros2 topic info /rov/test
ros2 topic echo /rov/test
ros2 topic pub /rov/test std_msgs/msg/String "{data: 'Hello ROV'}"
```

The outcome is a working model of `node → topic → message → publisher/subscriber`.
