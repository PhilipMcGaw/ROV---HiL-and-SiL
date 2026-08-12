# TF2 and ROV coordinate frames

Define the ROV frame hierarchy before adding detailed sensors. At minimum, document the vehicle body frame, inertial/world frame, depth reference, camera frame, and each simulated sensor frame.

Record frame names, axis directions, handedness, origins, and rotations. Do not infer a frame convention from a visual display. Heading, pitch, roll, depth, camera pitch, and thruster axes must use the documented convention.

Use TF2 inspection tools to confirm that transforms exist, are connected, and have current timestamps. Frame errors must be corrected before scenario results are treated as valid.

Relevant course stages: Day 1 for ROS graph concepts, Day 3 for the vehicle model, Day 4 for sensors, and Day 5 for the camera frame.
