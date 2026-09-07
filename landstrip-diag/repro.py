#!/usr/bin/env python3
"""Reproduce pi's exact landstrip invocation (socket fd 3 + real env/cwd/policy)."""
import os, subprocess, tempfile
import socket

REAL = "/home/shemishtamesh/.pi/agent/npm/node_modules/@landstrip/landstrip-linux-x64/bin/landstrip.real"
POLICY = "/tmp/lscap-policy.json"
CWD = "/home/shemishtamesh/.config/system"

ENV = {
    "HOME": "/home/shemishtamesh",
    "PWD": CWD,
    "PATH": "/run/current-system/sw/bin:/home/shemishtamesh/.nix-profile/bin:/etc/profiles/per-user/shemishtamesh/bin",
    "SHLVL": "1",
    "LANG": "en_US.UTF-8",
}
ENV.update(os.environ)
ENV["LANDSTRIP_CONTEXT"] = os.environ.get("LANDSTRIP_CONTEXT", "")

def run(label, fd_kind, trap_arg):
    kept = []
    if fd_kind == "socket":
        s1, s2 = socket.socketpair()
        os.dup2(s1.fileno(), 3); kept.append(s1); kept.append(s2)
    else:
        f = tempfile.TemporaryFile()
        os.dup2(f.fileno(), 3); kept.append(f)
    cmd = [REAL, "run"]
    if trap_arg:
        cmd += ["--trap-fd", "3"]
    cmd += ["-p", POLICY, "--", "/run/current-system/sw/bin/bash", "-c", "ls .."]
    try:
        r = subprocess.run(cmd, env=ENV, cwd=CWD, pass_fds=[3],
                           capture_output=True, text=True)
        print(f"--- {label} ---")
        if r.stdout.strip(): print("STDOUT:", r.stdout.strip())
        if r.stderr.strip(): print("STDERR:", r.stderr.strip())
        print("EXIT:", r.returncode)
    except Exception as e:
        print(f"--- {label} --- ERROR: {e!r}")
    finally:
        for x in kept: os.close(x)

run("A: socket fd3, no --trap-fd   ", "socket", False)
run("B: socket fd3, --trap-fd 3    ", "socket", True)
run("C: file   fd3, --trap-fd 3    ", "file",   True)