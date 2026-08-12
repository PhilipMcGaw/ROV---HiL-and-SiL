# URDF and Xacro vehicle modelling

Use URDF or Xacro to describe the simulated ROV links, joints, inertial properties, collision geometry, visual geometry, thrusters, and sensor mounts.

Begin with a simple model that loads reliably. Add hydrodynamic or geometric detail only after the model, frame tree, collision behaviour, and actuator interfaces are repeatable.

Validate the model by checking links, joints, inertial values, frame names, collision behaviour, and Gazebo loading. A model that renders is not necessarily physically representative or safe for control conclusions.

Relevant course stages: Day 3 for the basic model, Day 4 for actuator and sensor mounts, and Day 5 for camera placement.
