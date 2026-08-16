# ROV HiL and SiL Master Context

## 1. Purpose

The **ROV - HiL and SiL** repository provides an independent simulation and integration-test environment for the ROV project.

It allows the ROV software and associated systems to be developed and tested without requiring the physical ROV. It supports:

- **Software-in-the-loop (SiL)** operation using a fully simulated ROV.
- **Hardware-in-the-loop (HiL)** operation using external hardware connected through the ROV's NATS network.
- Offline development and testing.
- Repeatable simulation scenarios.
- Simulation of vehicle physics, actuators and sensors.
- Integration testing of the ROV software against the same NATS interfaces used by the real system.

The environment is intended to run in an **Ubuntu virtual machine or dedicated Ubuntu machine**, independently of the physical ROV.

The physical ROV and its Raspberry Pi hardware are **not dependencies of this repository**.

---

## 2. Project Repository Structure

The ROV project is divided into several repositories. Each repository has a defined responsibility.

| Repository | Responsibility |
|---|---|
| **ROV** | Generic project information, instructions, project-wide documentation and CAD files |
| **ROV - Cockpit** | ROV operator cockpit software; runs on the RPi |
| **ROV - Control** | ROV control software and hardware interface; runs on the RPi |
| **ROV - Datalogger** | ROV sensor and operational data recording; runs on the RPi |
| **ROV - HiL and SiL** | Independent simulation and integration-test environment; runs in an Ubuntu VM or dedicated Ubuntu machine |
| **ROV - Conductivity Temperature and Depth Transducer** | CTD electronics and KiCad design |
| **ROV - Light Module** | ROV lighting electronics and KiCad design |

The repositories are developed independently but communicate through defined interfaces where required.

The **ROV** repository provides generic project-level information and is the appropriate location for project-wide interface definitions and architectural information.

The **ROV - HiL and SiL** repository must not become the source of truth for the implementation of the real ROV.

---

## 3. HiL and SiL Definitions

### 3.1 Software-in-the-Loop

SiL means that the software system is operated against a completely simulated vehicle.

The physical ROV and RPi hardware are not required.

The simulation shall provide:

- vehicle dynamics;
- actuator behaviour;
- sensors;
- vehicle state;
- camera feeds;
- telemetry;
- NATS interfaces required by the ROV software.

SiL must support completely offline development.

### 3.2 Hardware-in-the-Loop

HiL means that real hardware or software components can be connected to the simulation environment and operate against the simulated vehicle.

HiL communication shall use the **same NATS network and NATS data contracts used by the real ROV**.

No separate simulation-specific hardware protocol shall be introduced merely to support HiL.

The current repository does not require the physical ROV or RPi controller to operate. Hardware-in-the-loop is an architectural capability that can be used when the relevant hardware is available.

---

## 4. System Boundaries

The HiL/SiL environment is deliberately independent of the other ROV repositories.

This repository does **not** contain:

- Cockpit implementation;
- Control implementation;
- Datalogger implementation;
- Raspberry Pi software;
- physical ROV hardware;
- KiCad hardware designs;
- application-specific Python runtime environments.

Cockpit, Control and Datalogger may be virtualised for SiL testing, but they **must run separately from the HiL/SiL environment**.

This separation ensures that the simulation does not accidentally become dependent on the runtime environment of one of the application repositories.

---

## 5. Communication Architecture

### 5.1 NATS

**NATS Core is the internal communication mechanism between ROV software components.**

NATS is used for:

- commands;
- telemetry;
- sensor data;
- actuator data;
- status information;
- other inter-component messages.

NATS JetStream is **not part of the ROV architecture**.

Persistent recording, historical data and black-box recording are responsibilities of the Datalogger.

The HiL/SiL environment shall communicate using the same NATS interfaces as the real ROV.

The simulation must not introduce a separate application-level communication protocol simply because it is running in simulation.

### 5.2 NATS Server

During real ROV operation, the NATS server runs on the robot/RPi environment.

For completely offline SiL operation, an equivalent NATS server must be available within the virtualised development environment.

The NATS server location may therefore differ between real and offline operation, but the application-level NATS interfaces shall remain consistent.

### 5.3 External interfaces

NATS is an **internal ROV communication mechanism**. It is not the protocol used directly between the operator's browser and the ROV.

The Cockpit communicates with the browser using appropriate web protocols, including HTTP and WebSockets.

The HiL/SiL environment must reproduce the behaviour required by those application interfaces rather than unnecessarily exposing ROS 2 directly to the browser or application services.

---

## 6. High-Level Architecture

### Offline SiL

```text
                    Ubuntu development environment

        ┌─────────────────────────────────────────┐
        │ Virtualised ROV services                │
        │                                         │
        │  Cockpit      Control      Datalogger   │
        │      \           |            /         │
        │               NATS                      │
        └──────────────────┬──────────────────────┘
                           │
                        NATS network
                           │
                           ▼
        ┌─────────────────────────────────────────┐
        │             HiL / SiL VM                │
        │                                         │
        │             NATS Bridge                 │
        │                  │                      │
        │                ROS 2                    │
        │                  │                      │
        │               Gazebo                    │
        │                  │                      │
        │          Simulated Vehicle              │
        │          Sensors / Camera               │
        └─────────────────────────────────────────┘
```

### Future HiL

```text
                         ROV / Hardware

        ┌─────────────────────────────────────────┐
        │ Raspberry Pi / Robot                    │
        │                                         │
        │  Cockpit      Control      Datalogger   │
        │      \           |            /         │
        │               NATS                      │
        └──────────────────┬──────────────────────┘
                           │
                        NATS network
                           │
                           ▼
        ┌─────────────────────────────────────────┐
        │             HiL / SiL VM                │
        │                                         │
        │             NATS Bridge                 │
        │                  │                      │
        │                ROS 2                    │
        │                  │                      │
        │               Gazebo                    │
        │                  │                      │
        │          Simulated Vehicle              │
        │          Sensors / Camera               │
        └─────────────────────────────────────────┘
```

The same NATS contracts are used in both cases.

The difference is whether the connected software and hardware are virtualised or physically present.

---

## 7. Application Responsibilities

### 7.1 Cockpit

The Cockpit is responsible for the operator interface.

Operator commands originate from the Cockpit.

The normal control path is:

```text
Operator
   │
Web Browser
   │
HTTP / WebSockets
   │
Cockpit
   │
NATS
   ▼
Control
```

The HiL/SiL environment must not generate operator commands independently of the Cockpit when testing the normal control path.

### 7.2 Control

Control is responsible for converting the Cockpit's commands into appropriate vehicle control and actuator commands.

In simulation, the HiL/SiL environment receives the resulting commands and simulates their effects.

Control logic should not be duplicated unnecessarily inside the simulator.

### 7.3 Datalogger

The Datalogger is an independent repository and service.

It records operational and sensor information from the ROV, including data such as:

- depth;
- pressure;
- conductivity/salinity;
- temperature;
- heading;
- IMU data;
- actuator state;
- other relevant vehicle telemetry.

The Datalogger may also provide a black-box recording capability in which NATS messages are recorded to allow reconstruction of system behaviour.

The Datalogger is not part of this repository.

HiL/SiL should nevertheless generate realistic NATS telemetry so that the external Datalogger can be tested against the simulated vehicle.

---

## 8. Camera Architecture

The camera is an application-facing system component.

### Real operation

A real ROV or other robot provides one or more real video feeds.

### Offline SiL

The HiL/SiL environment provides one or more simulated camera feeds using Gazebo or the appropriate simulation infrastructure.

The Cockpit should be able to consume the camera output without needing to know whether the source is a real camera or a simulated camera wherever practical.

The exact camera transport, encoding and streaming implementation is currently **deferred** and shall be determined from the existing Cockpit implementation and requirements.

Camera data does not need to be routed through NATS simply because NATS is used for internal ROV messaging.

---

## 9. Simulation Responsibilities

The HiL/SiL repository owns the simulated vehicles.

Vehicle models shall be organised under a dedicated top-level `vehicles/` directory.

The repository should support multiple simulated vehicles without requiring a redesign of the generic HiL/SiL infrastructure.

Vehicle-specific simulation content may include:

- hull geometry;
- mass and inertia;
- buoyancy;
- thrusters;
- actuator characteristics;
- propulsion configuration;
- sensors;
- camera placement;
- vehicle-specific ROS 2/Gazebo configuration.

Generic simulation infrastructure should remain separate from vehicle-specific content.

---

## 10. Simulation Physics

The initial simulation shall use **simple, understandable and repeatable physics**.

The first objective is to establish a reliable end-to-end system:

```text
Command
  ↓
NATS
  ↓
Control
  ↓
NATS
  ↓
HiL/SiL Bridge
  ↓
ROS 2
  ↓
Gazebo
  ↓
Vehicle / Actuator response
  ↓
Simulated Sensors
  ↓
NATS
  ↓
Telemetry consumers
```

Physical realism shall be added progressively.

The architecture must allow future improvements including:

- realistic mass and inertia;
- buoyancy;
- drag;
- thruster characteristics;
- actuator response;
- environmental effects;
- sensor noise and imperfections;
- other relevant vehicle dynamics.

Simulation complexity must not be increased before the basic command-to-telemetry loop is reliable and repeatable.

---

## 11. Simulation Timing

The primary target is **real-time simulation**.

There is currently no requirement for accelerated simulation.

Simulation time and ROS 2 time handling should nevertheless be implemented using ROS 2/Gazebo best practice so that future changes in simulation timing do not require architectural redesign.

---

## 12. Simulation Execution

The execution mode shall be controlled through configuration.

The repository should not require a large mode-selection framework.

Configuration should determine, as required:

- offline simulation;
- virtualised ROV services;
- external NATS connections;
- future hardware-in-the-loop operation;
- simulation configuration;
- selected vehicle;
- scenario configuration.

The same application-facing NATS contracts should be used regardless of execution mode.

---

## 13. Headless Operation

The simulation must support **headless execution**.

Repeatable scenarios should be capable of running without the Gazebo graphical interface.

This allows simulation and integration tests to be executed independently of a desktop GUI and provides a path towards automated regression testing.

The graphical Gazebo and RViz2 environments remain useful for development, debugging and visual inspection.

---

## 14. ROS 2 and Gazebo

ROS 2 and Gazebo are internal implementation technologies of this repository.

Cockpit, Control and Datalogger must not become directly dependent on ROS 2.

The current supported environment is:

- **Ubuntu 24.04 LTS AMD64**
- **ROS 2 Jazzy**
- **Gazebo Harmonic**

ROS 2/Gazebo integration shall follow current supported best practice, including the appropriate `ros_gz` integration where applicable.

Changes to the ROS 2 or Gazebo versions require verification of the complete supported combination, including:

- ROS 2;
- Gazebo;
- `ros_gz`;
- RViz2;
- relevant ROS 2 packages;
- relevant simulation packages.

All development and runtime environments for this project shall remain within Ubuntu environments.

---

## 15. Repository Layout

The intended repository structure is:

```text
ROV - HiL and SiL/
│
├── .github/
│
├── configs/
│
├── docs/
│
├── vehicles/
│   └── <vehicle-specific simulation content>
│
├── ros2_ws/
│   └── src/
│       └── <ROS 2 packages>
│
├── scenarios/
│
├── scripts/
│
├── tests/
│
├── ROS Course Material Notes/
│
├── CONTRIBUTING.md
├── LICENSE-*.txt
├── LICENSES.md
├── MASTER_CONTEXT.md
├── README.md
└── .gitignore
```

`ros2_ws/` is the authoritative ROS 2 colcon workspace.

ROS 2 packages belong under:

```text
ros2_ws/src/
```

Generated colcon output belongs under:

```text
ros2_ws/build/
ros2_ws/install/
ros2_ws/log/
```

These generated directories must not be committed to version control.

The obsolete top-level `ros2/` directory is not part of the intended repository structure.

---

## 16. Repository Directory Responsibilities

### `configs/`

Configuration for:

- NATS connections;
- HiL/SiL bridge;
- simulation;
- vehicles;
- environments;
- execution modes.

### `vehicles/`

Vehicle-specific simulation content.

### `ros2_ws/`

ROS 2 packages and the colcon workspace.

### `scenarios/`

Repeatable simulation and integration-test scenarios.

Each scenario should eventually define:

- initial conditions;
- selected vehicle;
- commands;
- expected vehicle response;
- expected telemetry;
- relevant pass/fail checks.

The exact scenario file format is deferred.

### `tests/`

Automated and manual repository tests, including documentation consistency checks.

### `scripts/`

Repository-specific setup, diagnostic, build and test utilities.

### `docs/`

Maintained technical documentation covering subjects such as:

- ROS 2;
- QoS;
- time;
- TF2;
- URDF/Xacro;
- Gazebo;
- sensor fidelity;
- simulation;
- NATS diagnostics;
- bridge operation;
- scenarios;
- testing;
- camera integration;
- safety boundaries.

### `ROS Course Material Notes/`

Background ROS learning and setup material.

This material supports development and training but is **not authoritative architecture documentation**.

The authoritative training order is maintained in:

```text
ROS Course Material Notes/INDEX.md
```

---

## 17. Development Environment

The supported HiL/SiL environment is:

```text
Ubuntu 24.04 LTS AMD64
ROS 2 Jazzy
Gazebo Harmonic
```

The environment may run in:

- a virtual machine on a development laptop; or
- dedicated Ubuntu hardware.

The virtualisation technology is an implementation choice and is not a runtime dependency of the repository.

The HiL/SiL environment must remain independently executable and must not depend on the Python runtime, virtual environment or Windows-specific deployment mechanisms of the ROV application repositories.

---

## 18. Engineering Rules

- NATS Core is the internal ROV communication mechanism.
- NATS JetStream is not used.
- The NATS contracts used by HiL/SiL must remain compatible with the real ROV interfaces.
- Do not expose ROS 2 directly as a dependency of Cockpit, Control or Datalogger.
- Do not duplicate application control logic inside the simulator.
- Start with simple, repeatable physics.
- Increase physical realism progressively.
- The physical ROV is not required for SiL.
- The RPi controller is not required for SiL.
- Future hardware integration shall use the existing NATS network and interfaces.
- The HiL/SiL repository must remain usable without hardware.
- Persistent operational and black-box data recording belongs to the Datalogger.
- Do not introduce a second persistence system into HiL/SiL without a specific requirement.
- Simulation scenarios must be reproducible.
- Repeatable scenarios must support headless operation.
- Build output must remain outside version control.
- Vehicle-specific simulation content belongs under `vehicles/`.
- Generic simulation infrastructure must remain separate from vehicle-specific implementation.
- Simulation success is not evidence that real hardware is safe or suitable for operation.

---

## 19. Safety Boundary

The simulation environment is a development and testing tool.

A successful simulation, HiL test or scenario does **not** demonstrate that the physical ROV or its hardware is safe.

Real hardware must be independently verified against appropriate engineering, electrical, mechanical, software and operational requirements.

The simulator must not be treated as a substitute for physical safety testing.

---

## 20. Documentation and Change Control

The enforceable documentation policy is:

```text
docs/documentation-policy.md
```

Contributor guidance is:

```text
CONTRIBUTING.md
```

Current repository status is:

```text
docs/status.md
```

Standard documentation checks include:

```text
tests/test_documentation.py
tests/documentation_change_policy.py
```

with path rules and intentional exemptions defined in:

```text
tests/documentation_change_policy.json
```

Changes to any of the following must update this master context and the relevant documentation in the same change:

- ROS distribution;
- Gazebo version;
- ROS/Gazebo integration;
- NATS bridge;
- NATS architecture;
- simulated sensors;
- vehicle models;
- simulation scenarios;
- workspace layout;
- execution modes;
- test process;
- major repository boundaries.

Every change must include a consistency check of this document.

If this document no longer accurately represents the current architecture or behaviour, it must be corrected as part of the same change.

Documentation shall use formal British English and be written for readers with an engineering degree or equivalent technical experience.

---

## 21. Units and Technical Writing

Where SI units are used, place a space between the numerical value and the unit symbol:

```text
5 m
12 V
20 °C
```

Use the degree symbol `°` by preference for angles.

Technical terminology should remain consistent across the repository.

Use:

- **HiL** — Hardware-in-the-Loop
- **SiL** — Software-in-the-Loop
- **RPi** — Raspberry Pi
- **ROS 2**
- **Gazebo**
- **NATS Core**

---

## 22. Shell and Repository Tooling

Where this repository uses POSIX shell scripts, they shall follow the same standards as the ROV application repositories for:

- verbose diagnostics;
- strict error handling;
- portable paths;
- prerequisite validation;
- avoidance of unapproved system changes.

Repository scripts must not silently modify the host system beyond their documented purpose.

---

## 23. Maintainer

**Name:** Philip McGaw

**Email:** philip@mcgaw.eu

**Website:** https://philipmcgaw.com