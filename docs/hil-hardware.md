# Hardware-in-the-loop hardware

The HiL/SiL machine is separate from the Raspberry Pi. Use a bridged or otherwise controlled network path to reach the NATS Server. The robot's default NATS listener is local-only; HiL/SiL requires an explicitly enabled, authenticated listener bound to the approved robot network interface and protected by firewall rules. Begin with simulation-only tests, then connect the Raspberry Pi with propulsion disabled or physically isolated.

Record the machine, ROS distribution, Gazebo version, network address, NATS configuration, and test state for every hardware-in-the-loop session.
