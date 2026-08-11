# Simulation and safety

HiL/SiL results validate software behaviour, not the safety of real propulsion. Keep physical power isolation available during hardware tests. Control must enforce neutral startup, command limits, timeouts, and emergency-stop behaviour independently of Cockpit, NATS, ROS 2, and Gazebo.
