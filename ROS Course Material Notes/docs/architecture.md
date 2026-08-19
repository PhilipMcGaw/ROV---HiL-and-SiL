# HiL/SiL Course Architecture

## Repository boundaries

```text
ROV
├── generic project information and instructions
└── CAD and design material

ROV---Cockpit
└── Cockpit software; normally runs on the Raspberry Pi

ROV---Control
└── Control software; interfaces application commands with hardware

ROV---Datalogger
└── Data recording service; normally runs on the Raspberry Pi

ROV---HiL-and-SiL
└── Offline simulation and hardware-in-the-loop environment

ROV - Conductivity Temperature and Depth Transducer
└── KiCad hardware design

ROV - Light Module
└── KiCad hardware design
```

## HiL/SiL boundary

```text
Cockpit ── NATS Core ── Control ── NATS Core ── HiL/SiL bridge ── ROS 2 ── Gazebo
   │                                                       │
   └──────────── HTTP / WebSocket / video ◄── camera ─────┘
```

For offline SiL, Cockpit, Control and Datalogger may be virtualised, but they should run in separate Ubuntu boxes/VMs rather than inside the HiL/SiL machine itself. They use the same NATS network.

The HiL/SiL machine owns the simulated vehicle models. Simulated vehicle packages live beneath `ros2_ws/src/` in this repository.

## Real hardware later

A physical Raspberry Pi robot may later connect to the same NATS network. The HiL/SiL environment must not require the RPi to operate in offline SiL mode.

```text
Real RPi robot ── NATS network ── HiL/SiL environment
```

The RPi is therefore a later HiL endpoint, not a prerequisite for the course.

## Communication rules

- NATS Core is the internal application communication layer.
- JetStream is not used.
- Camera/video is delivered using the established HTTP/video interface, not NATS.
- The ROS 2/Gazebo implementation is internal to HiL/SiL.
- Cockpit and Control must not become directly dependent on ROS 2.
- Datalogger remains a separate repository and provides persistence/black-box recording functions.

## Simulation philosophy

Start with simple, repeatable models. Add physical realism only after the command/telemetry loop is working and measurable.
