# Simulation safety and command boundaries

HiL/SiL results must never be treated as proof that physical propulsion or control behaviour is safe. The simulation is an integration and development aid.

Document command ranges, neutral values, timeout behaviour, emergency-stop assumptions, startup state, and the boundary between Cockpit, Control, NATS, ROS 2, and Gazebo. Keep physical power isolation available when connecting real hardware.

Each scenario must state whether it is SiL-only, uses a real Control service, uses physical sensors, or crosses another hardware boundary. A successful simulated scenario must not be labelled physically validated.

Relevant course stages: Day 4 for actuator limits, Day 6 for bridge boundaries, and Day 7 for scenario evidence.
