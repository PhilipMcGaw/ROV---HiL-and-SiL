# Automated scenario testing

Use `colcon test` and appropriate ROS 2 launch or integration tests to verify repeatable scenarios. Each test must state its environment, initial conditions, command sequence, expected actuator response, expected motion, expected telemetry, tolerances, timeout, and evidence output.

Tests should fail on missing, stale, non-numeric, incorrectly framed, or out-of-range telemetry rather than silently accepting it. Keep SiL-only tests separate from tests requiring the Raspberry Pi or other physical hardware.

Record test results with the software and scenario revisions. Automated-test verification does not establish bench-tested or production-validated status.

Relevant course stage: Day 7, with test design introduced during Days 4 and 6.
