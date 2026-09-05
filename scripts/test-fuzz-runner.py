#!/usr/bin/env python3
"""Check mutation reproducibility, failure retention, and actual process budgets."""

import importlib.util
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import Mock, patch

spec = importlib.util.spec_from_file_location(
    "fuzz_runner", Path(__file__).with_name("fuzz-parser.py")
)
fuzz = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fuzz)


class MutationTest(unittest.TestCase):
    def test_all_mutation_families_are_deterministic_and_bounded(self):
        seeds = [("first", bytes(range(32))), ("second", bytes(range(64)))]
        left = fuzz.mutations(seeds, 17)
        right = fuzz.mutations(seeds, 17)
        operations = set()
        for _ in range(200):
            value = next(left)
            self.assertEqual(value, next(right))
            self.assertLessEqual(len(value[2]), fuzz.MAX_INPUT)
            operations.add(value[1].split(":")[0])
        self.assertEqual(
            operations,
            {"unmodified", "truncate", "field16", "field32", "swap16", "bit", "delete"},
        )

    def test_failure_is_saved_with_reproduction_metadata(self):
        with tempfile.TemporaryDirectory() as directory:
            path = fuzz.retain_failure(
                Path(directory), b"bad font", {"seed": 17, "case": 3}
            )
            self.assertEqual(path.read_bytes(), b"bad font")
            self.assertIn('"seed": 17', path.with_suffix(".json").read_text())

    def test_oversized_input_is_rejected_before_launch(self):
        with self.assertRaisesRegex(ValueError, "maximum"):
            fuzz.run_input(Path("does-not-exist"), b"x" * (fuzz.MAX_INPUT + 1))

    def test_timeout_reaps_child_that_exits_before_kill(self):
        process = Mock(pid=12345)
        process.wait.side_effect = [fuzz.subprocess.TimeoutExpired(["worker"], 2), 0]
        with (
            patch.object(fuzz.sys, "platform", "linux"),
            patch.object(fuzz.subprocess, "Popen", return_value=process),
            patch.object(fuzz.os, "killpg", side_effect=ProcessLookupError) as kill,
        ):
            code, output, errors = fuzz.bounded_process(["worker"])
        self.assertEqual((code, output, errors), (124, "", ""))
        kill.assert_called_once_with(process.pid, fuzz.signal.SIGKILL)
        self.assertEqual(process.wait.call_count, 2)
        process.wait.assert_called_with()

    @unittest.skipUnless(
        sys.platform == "linux", "hard address-space budgets run in required Linux CI"
    )
    def test_address_space_limit_is_enforced(self):
        # mmap specifically proves limits cover virtual allocations, not only brk.
        code, _, _ = fuzz.bounded_process(
            [sys.executable, "-c", "import mmap; mmap.mmap(-1, 8 * 1024**3)"]
        )
        self.assertNotEqual(code, 0)

    @unittest.skipUnless(
        sys.platform == "linux", "kernel budget probes run in required Linux CI"
    )
    def test_hang_is_killed(self):
        code, _, _ = fuzz.bounded_process(
            [sys.executable, "-c", "import time; time.sleep(10)"], wall_seconds=0.1
        )
        self.assertEqual(code, 124)

    @unittest.skipUnless(
        sys.platform == "linux", "kernel budget probes run in required Linux CI"
    )
    def test_cpu_limit_is_enforced(self):
        code, _, _ = fuzz.bounded_process(
            [sys.executable, "-c", "while True: pass"], wall_seconds=5
        )
        self.assertLess(code, 0)


if __name__ == "__main__":
    unittest.main()
