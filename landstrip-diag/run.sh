#!/usr/bin/env bash
# Landstrip EBADFD diagnostic — run in a NORMAL terminal, NOT inside pi.
# Usage: bash /home/shemishtamesh/.config/system/landstrip-diag/run.sh

set -u
LND="$HOME/.pi/agent/npm/node_modules/@landstrip/landstrip-linux-x64/bin/landstrip"
DIAG="$HOME/.config/system/landstrip-diag"
BASH_BIN="$(command -v bash || echo /bin/sh)"

echo "===== landstrip version ====="
"$LND" --version || true
echo
echo "===== doctor ====="
"$LND" doctor; echo "exit=$?"

run() {
  local name="$1" policy="$2"; shift 2
  echo
  echo "===== run: $name ====="
  RUST_BACKTRACE=1 "$LND" --debug run "$@" -p "$policy" -- "$BASH_BIN" -c 'echo sandbox-ok' 2>&1
  echo "exit=$?"
}

run "shell-exact (pi shell policy, read stripped)"                 "$DIAG/shell-exact.json"

echo
echo "===== run: shell-exact + --trap-fd 3 (fd3 open) ====="
exec 3<>/dev/null
RUST_BACKTRACE=1 "$LND" --debug run --trap-fd 3 -p "$DIAG/shell-exact.json" -- "$BASH_BIN" -c 'echo sandbox-ok' 2>&1
echo "exit=$?"
exec 3>&-

run "shell-exact + httpProxyPort"                                  "$DIAG/shell-exact-proxy.json"

echo
echo "NOTE: if all above succeed, the pi-specific invocation (spawn/cwd/env/trap) is the remaining difference."