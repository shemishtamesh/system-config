#!/usr/bin/env python3
"""Bisect dev-device trigger: which path + does socket fd NUMBER matter."""
import os, socket, subprocess, tempfile, json

REAL = "/home/shemishtamesh/.pi/agent/npm/node_modules/@landstrip/landstrip-linux-x64/bin/landstrip.real"
CWD = "/home/shemishtamesh/.config/system"
ENV = {"HOME": "/home/shemishtamesh", "PWD": CWD, "PATH": "/run/current-system/sw/bin", "SHLVL": "1"}
ENV.update(os.environ)
NET = {"allowNetwork": False, "allowLocalBinding": False, "allowAllUnixSockets": False, "allowUnixSockets": []}
DEV = ["/dev/null","/dev/random","/dev/urandom","/dev/zero","/dev/stdin","/dev/stdout","/dev/stderr","/dev/tty"]

def policy(aw):
    return {"network": dict(NET), "filesystem": {"allowWrite": aw, "denyWrite": []}}

def run(label, allowWrite, fdno=3, typ="socket"):
    kept = []
    if typ == "socket":
        s1, s2 = socket.socketpair()
        os.dup2(s1.fileno(), fdno); kept = [s1, s2]
    else:  # file
        fd = os.open("/dev/null", os.O_RDWR); os.dup2(fd, fdno); kept = [fd]
    fd, path = tempfile.mkstemp(suffix=".json")
    with os.fdopen(fd, "w") as f:
        json.dump(policy(allowWrite), f)
    try:
        r = subprocess.run([REAL, "run", "-p", path, "--", "/run/current-system/sw/bin/sh", "-c", "true"],
                           env=ENV, cwd=CWD, pass_fds=[fdno], capture_output=True, text=True)
        ok = "sandbox" if r.returncode == 0 else r.stderr.strip().splitlines()[-1][:80]
        print(f"{label:46} exit={r.returncode} :: {ok}")
    finally:
        os.unlink(path)
        for x in kept:
            try: os.close(x.fileno())
            except Exception: pass

run("fd3 socket,  all 8 dev devices",     DEV, 3, "socket")
run("fd3 socket,  /dev/null alone",       ["/dev/null"], 3, "socket")
run("fd3 socket,  /dev/tty alone",        ["/dev/tty"], 3, "socket")
run("fd3 socket,  /dev/urandom alone",    ["/dev/urandom"], 3, "socket")
run("fd3 socket,  /dev/stdout alone",     ["/dev/stdout"], 3, "socket")
run("fd3 socket,  /dev/random alone",     ["/dev/random"], 3, "socket")
run("fd3 socket,  /dev/zero alone",       ["/dev/zero"], 3, "socket")
run("fd3 socket,  /dev/stdin alone",      ["/dev/stdin"], 3, "socket")
run("fd3 socket,  /dev/stderr alone",     ["/dev/stderr"], 3, "socket")
print()
run("fd3 FILE,    all 8 dev devices",     DEV, 3, "file")
run("fd100 socket, all 8 dev devices",    DEV, 100, "socket")
run("fd20 socket,  all 8 dev devices",    DEV, 20, "socket")
run("fd3 socket,  dev minus /dev/tty",    [d for d in DEV if d != "/dev/tty"], 3, "socket")
run("fd3 socket,  dev minus /dev/std*",   [d for d in DEV if "std" not in d], 3, "socket")