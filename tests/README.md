# HiL/SiL tests

Run `python tests/test_documentation.py` from the repository root. Pull-request paths are checked with `python tests/documentation_change_policy.py <changed paths>`.

Tests will cover ROS package behaviour, NATS bridge mappings, repeatable scenarios, and end-to-end command/telemetry flow. Tests must state whether they are SiL-only, require the Raspberry Pi, or require other hardware.
