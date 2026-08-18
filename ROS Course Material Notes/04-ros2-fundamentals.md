# Day 2 — ROS 2 application fundamentals

## Objective

Learn the ROS 2 communication and composition mechanisms required to build the HiL/SiL application. Generic programming, Linux and Git fundamentals are assumed.

## Nodes

Create two small nodes and inspect them:

```zsh
ros2 node list
ros2 node info <node>
```

Understand a node as a process/component participating in the ROS graph.

## Topics

Establish:

```text
publisher → topic → subscriber
```

Use:

```zsh
ros2 topic list
ros2 topic info <topic>
ros2 topic echo <topic>
ros2 topic hz <topic>
```

Topics are streams of typed messages.

## Services and actions

Exercise a simple service and compare request/response with topic streaming. Understand when a long-running operation is better represented by an action.

## Parameters

Use parameters for configuration rather than hard-coded values:

```zsh
ros2 param list
ros2 param get <node> <parameter>
ros2 param set <node> <parameter> <value>
```

## Launch

Create a launch file that starts a small ROS 2 graph. Use package-relative resource lookup rather than paths tied to the current directory.

## QoS

Learn the practical QoS concepts needed later for sensors and commands: reliability, durability, history, depth and publisher/subscriber compatibility.

## Project interfaces

Do not invent the ROV application protocol here. The NATS contract is the application integration boundary. ROS interfaces used by the bridge should map cleanly to that established contract.

## Exit criteria

- [ ] Two ROS 2 nodes communicate through a typed topic.
- [ ] A service has been exercised.
- [ ] Parameters can be inspected and changed.
- [ ] A launch file starts a small application graph.
- [ ] Basic QoS behaviour is understood.
- [ ] The ROS graph can be inspected from the command line.
