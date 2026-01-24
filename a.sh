#!/nix/store/lw117lsr8d585xs63kx5k233impyrq7q-bash-5.3p3/bin/bash
if [ "$1" = "kill" ]; then
  /nix/store/wiy3gbsp4f2zg5kkn456cv7hsqycpabq-noctalia-shell-2026-01-17_cd20b70/bin/noctalia-shell "$@"
  exit 0
fi
/nix/store/wiy3gbsp4f2zg5kkn456cv7hsqycpabq-noctalia-shell-2026-01-17_cd20b70/bin/noctalia-shell "$@"
sleep 3 # set location doesn't seem to work immediately
/nix/store/wiy3gbsp4f2zg5kkn456cv7hsqycpabq-noctalia-shell-2026-01-17_cd20b70/bin/noctalia-shell ipc call location set "$(cat /home/shemishtamesh/.config/sops-nix/secrets/location)"

