#!/usr/bin/env python3
"""Confirm fix under PI-EXACT invocation: socketpair at fd 3 + --trap-fd 3."""
import os, socket, subprocess, tempfile, json

REAL = "/home/shemishtamesh/.pi/agent/npm/node_modules/@landstrip/landstrip-linux-x64/bin/landstrip.real"
CWD = "/home/shemishtamesh/.config/system"
ENV = {"HOME": "/home/shemishtamesh", "PWD": CWD, "PATH": "/run/current-system/sw/bin", "SHLVL": "1"}
ENV.update(os.environ)
NET = {"allowNetwork": False, "allowLocalBinding": False, "allowAllUnixSockets": False, "allowUnixSockets": []}
FULL = ["/dev/null","/dev/random","/dev/urandom","/dev/zero","/dev/stdin","/dev/stdout","/dev/stderr","/dev/tty"]
FIXED = ["/dev/null","/dev/random","/dev/urandom","/dev/zero","/dev/stdin","/dev/tty"]  # minus stdout/stderr

def policy(aw):
    return {"network": dict(NET), "filesystem": {
        "allowWrite": [".", "/tmp/pi-agent"] + aw,
        "denyWrite": ["**/.env","**/.env.*","**/*.pem","**/*.key","**/.netrc","**/.npmrc","**/.pypirc","**/.git-credentials",".pi/"],
    }}

def run(label, aw):
    s1, s2 = socket.socketpair(); os.dup2(s1.fileno(), 3)
    fd, path = tempfile.mkstemp(suffix=".json")
    with os.fdopen(fd, "w") as f:
        json.dump(policy(aw), f)
    try:
        cmd = [REAL, "run", "--trap-fd", "3", "-p", path, "--", "/run/current-system/sw/bin/sh", "-c", "true"]
        r = subprocess.run(cmd, env=ENV, cwd=CWD, pass_fds=[3], capture_output=True, text=True)
        ok = "sandbox-ok" if r.returncode == 0 else r.stderr.strip().splitlines()[-1][:70]
        print(f"{label:46} exit={r.returncode} :: {ok}")
    finally:
        os.unlink(path)
        for x in (s1, s2):
            try: os.close(x.fileno())
            except Exception: pass

run("pi-exact full dev (reproduce)",           FULL)
run("pi-exact FIXED (no stdout/stderr)",       FIXED)
run("pi-exact FIXED + we still get trap",      FIXED)