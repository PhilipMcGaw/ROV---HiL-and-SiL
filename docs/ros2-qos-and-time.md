# ROS 2 QoS and time

ROS 2 Quality of Service (QoS) settings affect whether simulated commands and telemetry are delivered. Record the chosen reliability, durability, history, depth, and deadline settings for every ROV-facing topic.

Use one clock convention throughout the simulation. Distinguish simulation time from wall-clock time, and ensure sensor timestamps, bridge timestamps, and scenario assertions use the intended clock.

Before integration, verify topic QoS with `ros2 topic info --verbose`, check timestamps, and document any intentional mismatch. A simulation that appears visually correct but has stale or incompatible timestamps is not integration-validated.

Relevant course stages: Day 1 for ROS concepts, Day 4 for sensor rates and timestamps, and Day 6 for bridge compatibility.
