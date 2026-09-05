#!/usr/bin/env python3
"""Exercise the actual offline generator, including deliberate table drift."""

import importlib.util
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parent.parent
GENERATOR = ROOT / "scripts/generate-unicode-scripts.py"
spec = importlib.util.spec_from_file_location("unicode_generator", GENERATOR)
generator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(generator)


class UnicodeGenerationTest(unittest.TestCase):
    def test_offline_generation_drift_and_clean_regeneration(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "unicode.mojo"
            command = [sys.executable, str(GENERATOR), "--output", str(output)]
            # Network access during generation is a test failure, even with cache.
            with patch.object(
                generator.urllib.request, "urlopen", side_effect=AssertionError
            ):
                expected = generator.generate(generator.SOURCE_DIR)
            self.assertEqual(generator.OUTPUT.read_text(), expected)
            output.write_text(
                expected.replace(
                    "_UNICODE_SCRIPT_COUNT = 176", "_UNICODE_SCRIPT_COUNT = 175", 1
                )
            )
            result = subprocess.run(
                command + ["--check"], capture_output=True, text=True, timeout=60
            )
            self.assertEqual(result.returncode, 1, result.stderr)
            self.assertIn("generated Unicode data is stale", result.stderr)
            subprocess.run(command, check=True, capture_output=True, timeout=60)
            self.assertEqual(output.read_text(), expected)
            subprocess.run(
                command + ["--check"], check=True, capture_output=True, timeout=60
            )

    def test_changed_upstream_input_is_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)
            (path / "Scripts.txt").write_bytes(
                (generator.SOURCE_DIR / "Scripts.txt").read_bytes() + b"\n"
            )
            with self.assertRaisesRegex(
                RuntimeError, "checksum mismatch for Scripts.txt"
            ):
                generator.read_source("Scripts.txt", path)


if __name__ == "__main__":
    unittest.main()
