# Troubleshooting

## ROS commands are unavailable

Source the ROS environment:

```bash
source /opt/ros/jazzy/setup.zsh
```

## Gazebo is slow or unstable

Check VMware 3D acceleration, reduce world complexity, and start with a simple model. Keep the VM responsive enough to inspect logs.

## NATS cannot be reached

Check the network mode, server address, TCP port `4222`, firewall rules, and whether the NATS Server is listening on the Raspberry Pi.

## The scenario is not repeatable

Check initial conditions, random seeds, sensor noise, model parameters, and stale ROS 2 nodes before changing the scenario itself.
