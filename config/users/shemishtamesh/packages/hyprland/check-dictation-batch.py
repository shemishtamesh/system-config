#!/usr/bin/env python3
"""Compare one large Hyprland typing batch with bounded batches.

Run from a terminal, then focus an empty disposable editor before the countdown
ends. This TYPES test text into that window; it does not send Enter.
"""

import argparse
import json
import subprocess
import time

from dictation import batches, shortcut


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mode", choices=["single", "batched"])
    parser.add_argument("--characters", type=int, default=2000)
    parser.add_argument("--delay", type=float, default=5)
    args = parser.parse_args()
    if not 1 <= args.characters <= 20000 or args.delay < 0:
        parser.error("Use 1–20000 characters and a nonnegative delay")

    print(f"Will type {args.characters} characters in {args.delay:g}s.", flush=True)
    print("Focus an EMPTY disposable editor now. Do not close it during the test.", flush=True)
    time.sleep(args.delay)
    window = json.loads(subprocess.check_output(
        ["hyprctl", "activewindow", "-j"], text=True,
    ))
    address = window.get("address")
    if not address or address == "0x0":
        raise SystemExit("No active target window")
    print(f"Target: {address}", flush=True)

    # Repeated, numbered 10-character blocks make the result countable.
    text = "".join(f"{i % 1000000000:09d} "
                   for i in range((args.characters + 9) // 10))[:args.characters]
    commands = ["dispatch " + shortcut("address:" + address, "", char if char != " " else "space")
                for char in text]
    requests = [";".join(commands)] if args.mode == "single" else list(batches(commands))
    print(f"Mode: {args.mode}; requests: {len(requests)}; "
          f"largest argument: {max(len(r.encode()) for r in requests):,} bytes", flush=True)
    start = time.monotonic()
    for index, request in enumerate(requests, 1):
        try:
            result = subprocess.run(
                ["hyprctl", "--quiet", "--batch", request],
                capture_output=True, text=True, timeout=30,
            )
        except (OSError, subprocess.TimeoutExpired) as exc:
            raise SystemExit(f"Request {index}/{len(requests)} failed: {exc}") from exc
        if result.returncode:
            raise SystemExit(
                f"Request {index}/{len(requests)} exited {result.returncode}\n"
                f"{result.stdout}\n{result.stderr}"
            )
        if result.stdout.strip() or result.stderr.strip():
            print(f"Request {index} response: {result.stdout.strip()} {result.stderr.strip()}")
    print(f"Commands returned successfully in {time.monotonic() - start:.2f}s.")
    print(f"Check that the editor received exactly {len(text)} characters.")
    print("Success exit codes alone do not prove all keystrokes arrived.")


if __name__ == "__main__":
    main()
