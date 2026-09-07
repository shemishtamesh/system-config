#!/usr/bin/env bash
# Installs a capture wrapper around the landstrip binary so we can see the
# EXACT argv, cwd, env, and policy file pi passes to it when it EBADFDs.
# Run: bash landstrip-diag/setup.sh
set -u
REAL="$HOME/.pi/agent/npm/node_modules/@landstrip/landstrip-linux-x64/bin/landstrip"
if [ -e "$REAL.real" ]; then
  echo "wrapper already installed (found $REAL.real). Remove it first to reinstall."
  exit 1
fi
B="$(command -v bash || echo /bin/sh)"
mv "$REAL" "$REAL.real"
cat > "$REAL" <<WRAP
#!$B
{
  echo 'ARGS:' "\$@"
  echo 'CWD:' "\$(pwd)"
  echo '--- ENV ---'
  env | sort
} > /tmp/lscap.txt
prev=
for a in "\$@"; do
  if [ "\$prev" = "-p" ]; then cp "\$a" /tmp/lscap-policy.json; fi
  prev="\$a"
done
exec "$REAL.real" "\$@"
WRAP
chmod +x "$REAL"
echo "capture wrapper installed at:"
echo "  $REAL"
echo
echo "REAL binary preserved at:"
echo "  $REAL.real"
echo
echo "NEXT:"
echo "  1. start pi and run one failing command (e.g. 'ls')"
echo "  2. in a terminal, paste the contents of:"
echo "       /tmp/lscap.txt          (argv, cwd, env)"
echo "       /tmp/lscap-policy.json  (exact policy pi handed to the binary)"
echo
echo "TO RESTORE when done:"
echo "  mv \"$REAL.real\" \"$REAL\""