# NATS diagnostics and network troubleshooting

Verify the NATS server address, port, subject permissions, reachability, and client connection before diagnosing ROS 2 bridge behaviour. Use small, known test messages before introducing the complete ROV contract.

Record the NATS URL, subject, payload encoding, timestamp, client identity, and observed error. Distinguish server unavailable, network unreachable, permission denied, subject mismatch, invalid payload, and bridge processing failure.

The Raspberry Pi remains the NATS authority for the integration environment. HiL/SiL must not silently create a second authority or change the production subject contract. Remote access must be deliberately enabled, authenticated, bound to the approved robot interface, and firewall-restricted; localhost-only remains the default for a robot-only deployment.

Relevant course stages: Day 0.5 for basic connectivity and Day 6 for bridge diagnostics.
