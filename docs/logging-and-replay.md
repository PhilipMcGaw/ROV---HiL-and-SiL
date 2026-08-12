# Logging, rosbag recording, and replay

Record the commands, simulated actuator outputs, poses, sensor values, bridge messages, timestamps, scenario identifier, software revision, and configuration revision needed to reproduce a result.

Use ROS 2 bag recording and replay where appropriate. State which topics were recorded, the clock mode used, the recording duration, and any excluded topics. Store result summaries separately from raw recordings and do not overwrite evidence.

Replay must identify whether the system is observing historical data or actively controlling a simulation. It must not be confused with a live test.

Relevant course stages: Day 4 for sensor data, Day 6 for bridge data, and Day 7 for repeatable evidence.
