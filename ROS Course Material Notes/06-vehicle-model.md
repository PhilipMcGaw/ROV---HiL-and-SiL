# Day 4 — Vehicle model and actuation

## Objective

Create the first ROV-like vehicle and establish a simple, measurable command-to-motion loop.

## Repository location

Simulated vehicles will live in this repository under the ROS 2 workspace, normally beneath `ros2_ws/src/`.

```text
ROV---HiL-and-SiL/
├── ros2_ws/src/
│   └── ROV/
├── ros2_ws/
├── configs/
├── scenarios/
├── tests/
└── docs/
```

## First model

Start with a hull, thrusters, simple collision geometry and basic dynamics. Favour repeatability over realism.

## Command-to-motion loop

```text
command
  ↓
thruster model
  ↓
vehicle motion
```

Verify progressively:

```text
forward command → forward response
turn command → yaw response
dive command → depth response
```

Do not claim physical validity from a visually convincing simulation.

## Increasing realism

Only after the simple model is repeatable, consider realistic mass/inertia, centre of mass, centre of buoyancy, buoyancy, drag, thruster curves and actuator dynamics.

## Exit criteria

- [ ] Vehicle loads reliably.
- [ ] Thruster commands can be applied in ROS 2.
- [ ] Forward, turning and vertical responses are measurable.
- [ ] Vehicle parameters are identified as justified values or placeholders.
- [ ] The model is ready for sensor integration.
