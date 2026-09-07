#!/usr/bin/env python3
"""Under a socket at fd 3 (pi's condition), bisect which rule triggers EBADFD."""
import os, socket, subprocess, tempfile, json

REAL = "/home/shemishtamesh/.pi/agent/npm/node_modules/@landstrip/landstrip-linux-x64/bin/landstrip.real"
CWD = "/home/shemishtamesh/.config/system"
ENV = {"HOME": "/home/shemishtamesh", "PWD": CWD, "PATH": "/run/current-system/sw/bin", "SHLVL": "1"}
ENV.update(os.environ)

def base(allowWrite, allowRead=None, denyRead=None, net=None, windows=None, allowUnixSockets=None):
    p = {
        "network": net or {"allowNetwork": False, "allowLocalBinding": False,
                           "allowAllUnixSockets": False, "allowUnixSockets": allowUnixSockets or []},
        "filesystem": {
            "allowWrite": allowWrite,
            "denyWrite": [],
        },
    }
    if allowRead is not None:
        p["filesystem"]["allowRead"] = allowRead
        p["filesystem"]["denyRead"] = denyRead or []
    if windows:
        p["windows"] = windows
    return p

def run(label, policy, socket_fd3=True):
    kept = []
    if socket_fd3:
        s1, s2 = socket.socketpair(); os.dup2(s1.fileno(), 3); kept = [s1, s2]
    fd, path = tempfile.mkstemp(suffix=".json")
    with os.fdopen(fd, "w") as f:
        json.dump(policy, f)
    try:
        r = subprocess.run([REAL, "run", "-p", path, "--", "/run/current-system/sw/bin/sh", "-c", "true"],
                           env=ENV, cwd=CWD, pass_fds=[3] if socket_fd3 else [],
                           capture_output=True, text=True)
        ok = "sandbox" if r.returncode == 0 else r.stderr.strip()[:120]
        print(f"{label:48} exit={r.returncode} :: {ok}")
    finally:
        os.unlink(path)
        for x in kept:
            try: os.close(x.fileno())
            except Exception: pass

windows = {"appContainerMode": "standard", "allowLoopback": False}

run("no socket, allowWrite ['.'] control",         base(["."]),                      socket_fd3=False)
run("socket,  allowWrite ['.']",                  base(["."]),                      socket_fd3=True)
run("socket,  allowWrite [] (no write rules)",    base([]),                         socket_fd3=True)
run("socket,  allowWrite dev devices",            base(["/dev/null","/dev/random","/dev/urandom","/dev/zero","/dev/stdin","/dev/stdout","/dev/stderr","/dev/tty"]), socket_fd3=True)
run("socket,  allowWrite [\".\", '/tmp/pi-agent']", base([".", "/tmp/pi-agent"]),    socket_fd3=True)
run("socket,  + denyWrite globs",                  dict(base(["."]), **{"filesystem":{"allowWrite":["."],"denyWrite":["**/.env","**/*.pem","**/*.key"]}}), socket_fd3=True)
run("socket,  + read rules (denyRead allowRead)",  base(["."], allowRead=["."], denyRead=["/home"]), socket_fd3=True)
run("socket,  + windows block",                    base(["."], windows=windows),    socket_fd3=True)