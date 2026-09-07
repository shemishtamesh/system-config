#!/usr/bin/env python3
"""Repair the mangled default.nix from the failed edit call."""
import sys

P = "/home/shemishtamesh/.config/system/config/users/shemishtamesh/packages/coding-agents/pi/default.nix"
src = open(P).read()
orig = src

# ---- Fix 1: corrupted devAllowPaths block ----
start_marker = "  # utility device files"
end_marker = "  # keep every exact deny"
s = src.index(start_marker)
e = src.index(end_marker)
clean_block = '''  # utility device files
  #
  # NOTE: /dev/stdout and /dev/stderr (symlinks to the already-open fds 1 and
  # 2) MUST NOT be listed here. landstrip 0.18.43 EBADFDs
  # ('SANDBOX_SETUP_FAILED [landlock]: failed to add a rule: File descriptor in
  # bad state (os error 77)') whenever it installs a write rule for them while
  # any extra open fd exists (pi always leaves its trap socketpair at fd 3).
  # Inherited stdio fds are not restricted by Landlock, so the sandboxed tool
  # still writes to stdout/stderr normally without these rules.
  devAllowPaths = [
    "/dev/null"
    "/dev/urandom"
    "/dev/random"
    "/dev/zero"
    "/dev/stdin"
    "/dev/tty"
  ];

'''
src = src[:s] + clean_block + src[e:]

# ---- Fix 2: revert TEMP DIAGNOSTIC shell.readAccess ----
old_diag = '''  landstripSandboxPolicy = {
    enabled = true;
    # TEMP DIAGNOSTIC: was "policy". Setting to "host" disables the
    # restricted-read Landlock path (full-/ scan + read rules) to test whether
    # the EBADFD (failed to add a rule) comes from the read rules. Revert to
    # "policy" after diagnosing.
    shell.readAccess = "host";'''
new_diag = '''  landstripSandboxPolicy = {
    enabled = true;
    shell.readAccess = "policy";'''
if old_diag in src:
    src = src.replace(old_diag, new_diag)
elif 'shell.readAccess = "host";' in src:
    src = src.replace('shell.readAccess = "host";', 'shell.readAccess = "policy";')
else:
    print("WARN: could not locate readAccess diag, skipping fix2")
    print("(searching context... not found)")

open(P, "w").write(src)
print("DIFF:")
# crude line diff
before = orig.splitlines()
after = src.splitlines()
import difflib
for line in difflib.unified_diff(before, after, "before", "after", lineterm=""):
    print(line)