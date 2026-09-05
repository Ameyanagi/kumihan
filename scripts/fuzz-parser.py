#!/usr/bin/env python3
"""Deterministic mutation runner with Linux kernel resource limits per input."""

from __future__ import annotations

import argparse
import hashlib
import json
import itertools
import os
from pathlib import Path
import random
import resource
import signal
import subprocess
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parent.parent
MAX_INPUT = 16_384
MEMORY_BYTES = 4 * 1024 * 1024 * 1024
OUTPUT_BYTES = 64 * 1024
CPU_SECONDS = 1
WALL_SECONDS = 2
DEFAULT_SEED = 0x4B554D49


def resource_limits() -> None:
    # AS covers mmap too. Mojo 1.0 TCMalloc reserves 1 GiB arenas even for
    # tiny inputs, so a 4 GiB virtual ceiling permits runtime initialization.
    resource.setrlimit(resource.RLIMIT_AS, (MEMORY_BYTES, MEMORY_BYTES))
    resource.setrlimit(resource.RLIMIT_CPU, (CPU_SECONDS, CPU_SECONDS))
    resource.setrlimit(resource.RLIMIT_FSIZE, (OUTPUT_BYTES, OUTPUT_BYTES))
    resource.setrlimit(resource.RLIMIT_CORE, (0, 0))
    resource.setrlimit(resource.RLIMIT_NOFILE, (32, 32))


def bounded_process(
    command: list[str], wall_seconds: float = WALL_SECONDS
) -> tuple[int, str, str]:
    if sys.platform != "linux":
        raise RuntimeError(
            "hard RLIMIT_AS enforcement requires Linux; run fuzz-smoke in Linux CI"
        )
    with tempfile.TemporaryFile() as output, tempfile.TemporaryFile() as errors:
        process = subprocess.Popen(
            command,
            stdin=subprocess.DEVNULL,
            stdout=output,
            stderr=errors,
            start_new_session=True,
            preexec_fn=resource_limits,
        )
        try:
            process.wait(timeout=wall_seconds)
            code = process.returncode
        except subprocess.TimeoutExpired:
            try:
                os.killpg(process.pid, signal.SIGKILL)
            except ProcessLookupError:
                # The child can exit between the deadline and the signal.
                pass
            process.wait()
            code = 124
        output.seek(0)
        errors.seek(0)
        return (
            code,
            output.read(OUTPUT_BYTES).decode("utf-8", "replace").strip(),
            errors.read(OUTPUT_BYTES).decode("utf-8", "replace"),
        )


def corpus(worker: Path) -> list[tuple[str, bytes]]:
    code, output, errors = bounded_process([str(worker), "--corpus"])
    if code:
        raise RuntimeError(f"fixture exporter failed: {code}: {errors}")
    seeds = []
    for line in output.splitlines():
        name, encoded = line.split()
        data = bytes.fromhex(encoded)
        if not 0 < len(data) <= MAX_INPUT:
            raise RuntimeError(f"invalid fixture size: {name}: {len(data)}")
        seeds.append((name, data))
    if len(seeds) != 9 or len({name for name, _ in seeds}) != len(seeds):
        raise RuntimeError(
            "fixture exporter must provide all nine distinct format seeds"
        )
    return seeds


def mutation_sites(data: bytes) -> tuple[list[int], list[int], list[int]]:
    """Identify count/offset fields and actual GSUB coverage arrays in valid seeds."""

    def u16(offset):
        return int.from_bytes(data[offset : offset + 2], "big")

    def u32(offset):
        return int.from_bytes(data[offset : offset + 4], "big")

    short_fields, long_fields, coverage_pairs = [], [], []
    if data[:4] == b"ttcf":
        long_fields.append(8)
        faces = [u32(12 + 4 * index) for index in range(u32(8))]
        long_fields.extend(12 + 4 * index for index in range(len(faces)))
    else:
        faces = [0]
    for face in faces:
        short_fields.append(face + 4)
        for index in range(u16(face + 4)):
            record = face + 12 + 16 * index
            long_fields.extend([record + 8, record + 12])
            start = u32(record + 8)
            tag = data[record : record + 4]
            if tag == b"cmap":
                short_fields.append(start + 2)
                for entry in range(u16(start + 2)):
                    offset = start + 4 + entry * 8 + 4
                    long_fields.append(offset)
                    subtable = start + u32(offset)
                    format_id = u16(subtable)
                    if format_id == 4:
                        short_fields.extend([subtable + 2, subtable + 6])
                    elif format_id == 12:
                        long_fields.extend([subtable + 4, subtable + 12])
                    elif format_id == 14:
                        long_fields.extend([subtable + 2, subtable + 6])
                        for selector in range(u32(subtable + 6)):
                            long_fields.extend(
                                [
                                    subtable + 13 + selector * 11,
                                    subtable + 17 + selector * 11,
                                ]
                            )
            elif tag == b"GSUB":
                short_fields.extend([start + 4, start + 6, start + 8])
                for field in [4, 6, 8]:
                    short_fields.append(start + u16(start + field))
                lookup_list = start + u16(start + 8)
                for lookup_index in range(u16(lookup_list)):
                    field = lookup_list + 2 + lookup_index * 2
                    short_fields.append(field)
                    lookup = lookup_list + u16(field)
                    short_fields.append(lookup + 4)
                    for sub_index in range(u16(lookup + 4)):
                        field = lookup + 6 + sub_index * 2
                        short_fields.append(field)
                        subtable = lookup + u16(field)
                        if u16(lookup) != 1:
                            continue
                        short_fields.append(subtable + 2)
                        coverage = subtable + u16(subtable + 2)
                        short_fields.append(coverage + 2)
                        if u16(coverage) == 1 and u16(coverage + 2) >= 2:
                            coverage_pairs.append(coverage + 4)
    return short_fields, long_fields, coverage_pairs


def mutations(seeds: list[tuple[str, bytes]], seed: int):
    """Cycle every seed and mutation family before repeating a family/seed pair."""
    randomizer = random.Random(seed)
    sites = {
        name: mutation_sites(data) if data[:4]
        in (b"\x00\x01\x00\x00", b"OTTO", b"ttcf") else ([], [], [])
        for name, data in seeds
    }
    for name, data in seeds:
        yield name, "unmodified", data
    iteration = 0
    while True:
        name, original = seeds[iteration % len(seeds)]
        operation = (iteration // len(seeds)) % 6
        data = bytearray(original)
        offset = randomizer.randrange(len(data))
        if operation == 0:
            # Every possible prefix can be selected, including empty input.
            data = data[: randomizer.randrange(len(data))]
            description = f"truncate:{len(data)}"
        elif operation in (1, 2):
            width = 2 if operation == 1 else 4
            fields = sites[name][operation - 1]
            offset = randomizer.choice(fields) if fields else randomizer.randrange(
                len(data) - width + 1
            )
            maximum = (1 << (width * 8)) - 1
            value = randomizer.choice(
                [0, 1, len(data) - 1, len(data), len(data) + 1, maximum // 2, maximum]
            )
            data[offset : offset + width] = value.to_bytes(width, "big")
            description = f"field{width * 8}:{offset}:{value}"
        elif operation == 3:
            # Swap adjacent 16-bit coverage values / record fields, often
            # breaking sorted ordering while preserving table byte lengths.
            pairs = sites[name][2]
            offset = (
                randomizer.choice(pairs) if pairs else randomizer.randrange(
                    (len(data) - 4) // 2 + 1
                )
                * 2
            )
            data[offset : offset + 4] = (
                data[offset + 2 : offset + 4] + data[offset : offset + 2]
            )
            description = f"swap16:{offset}"
        elif operation == 4:
            bit = 1 << randomizer.randrange(8)
            data[offset] ^= bit
            description = f"bit:{offset}:{bit}"
        else:
            count = randomizer.randrange(1, min(32, len(data) - offset) + 1)
            del data[offset : offset + count]
            description = f"delete:{offset}:{count}"
        yield name, description, bytes(data)
        iteration += 1


def retain_failure(directory: Path, data: bytes, details: dict) -> Path:
    directory.mkdir(parents=True, exist_ok=True)
    digest = hashlib.sha256(data).hexdigest()
    path = directory / f"{digest}.bin"
    path.write_bytes(data)
    (directory / f"{digest}.json").write_text(
        json.dumps(details | {"sha256": digest}, indent=2) + "\n"
    )
    return path


def run_input(worker: Path, data: bytes) -> tuple[int, str, str]:
    if len(data) > MAX_INPUT:
        raise ValueError(f"input has {len(data)} bytes; maximum is {MAX_INPUT}")
    return bounded_process([str(worker), data.hex()])


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--worker", type=Path, default=ROOT / ".pixi/parser-fuzz-worker"
    )
    parser.add_argument("--cases", type=int, default=256)
    parser.add_argument(
        "--seed", type=lambda value: int(value, 0), default=DEFAULT_SEED
    )
    parser.add_argument("--campaign-seconds", type=int, default=300)
    parser.add_argument("--replay", type=Path)
    parser.add_argument("--failures", type=Path, default=ROOT / ".pixi/fuzz-failures")
    args = parser.parse_args()
    if not 63 <= args.cases <= 50_000:
        parser.error("--cases must be between 63 (all seed/mutation pairs) and 50000")
    if not 1 <= args.campaign_seconds <= 1200:
        parser.error("--campaign-seconds must be between 1 and 1200")
    worker = args.worker.resolve()
    started = time.monotonic()
    outcomes = {"VALID": 0, "PARSE_ERROR": 0}
    if args.replay:
        if args.replay.stat().st_size > MAX_INPUT:
            parser.error(f"--replay input exceeds {MAX_INPUT} bytes")
        cases = [(args.replay.name, "replay", args.replay.read_bytes())]
    else:

        def regressions():
            for path in sorted((ROOT / "tests/fuzz/regressions").glob("*.bin")):
                if path.stat().st_size > MAX_INPUT:
                    raise ValueError(f"regression exceeds {MAX_INPUT} bytes: {path}")
                yield path.name, "regression", path.read_bytes()

        generated = mutations(corpus(worker), args.seed)
        cases = itertools.chain(regressions(), itertools.islice(generated, args.cases))
    count = 0
    for index, (name, operation, data) in enumerate(cases):
        code, output, errors = run_input(worker, data)
        details = {
            "seed": args.seed,
            "case": index,
            "fixture": name,
            "mutation": operation,
            "returncode": code,
            "stdout": output,
            "stderr": errors,
            "input_limit": MAX_INPUT,
            "memory_bytes": MEMORY_BYTES,
            "cpu_seconds": CPU_SECONDS,
            "wall_seconds": WALL_SECONDS,
        }
        if (
            code != 0
            or output not in outcomes
            or (operation == "unmodified" and output != "VALID")
        ):
            path = retain_failure(args.failures, data, details)
            print(
                f"FAIL {json.dumps(details)}\nRetained input: {path}", file=sys.stderr
            )
            return 1
        outcomes[output] += 1
        count += 1
        if time.monotonic() - started > args.campaign_seconds:
            print(
                f"campaign exceeded {args.campaign_seconds}s after {count} inputs; incomplete",
                file=sys.stderr,
            )
            return 1
    print(
        json.dumps(
            {
                "seed": args.seed,
                "cases": count,
                "outcomes": outcomes,
                "seconds": round(time.monotonic() - started, 3),
                "memory_bytes": MEMORY_BYTES,
                "cpu_seconds_per_input": CPU_SECONDS,
                "wall_seconds_per_input": WALL_SECONDS,
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
