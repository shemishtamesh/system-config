pkgs:
let
  ddcutil = "${pkgs.ddcutil}/bin/ddcutil";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  bc = "${pkgs.bc}/bin/bc";

  reload_configs = pkgs.lib.getExe (
    pkgs.writeShellScriptBin "reload_configurations" ''
      if command -v tmux &>/dev/null && tmux info &>/dev/null; then
        tmux source-file ~/.config/tmux/tmux.conf
      fi

      if command -v noctalia-shell &>/dev/null; then
        noctalia-shell ipc call wallpaper toggleAutomation
        noctalia-shell ipc call wallpaper toggleAutomation
      fi
    ''
  );
in
{
  sync_external_monitors_brightness = pkgs.lib.getExe (
    pkgs.writeShellScriptBin "sync_external_monitors_brightness" ''
      ${ddcutil} setvcp 10 $(echo \"$(echo \"$(${brightnessctl} g) / $(${brightnessctl} m) * 100\" | ${bc} -l | ${bc}) / 1\" | ${bc})
    ''
  );
  set_brightness = pkgs.lib.getExe (
    pkgs.writeShellScriptBin "set_brightness" ''
      ${ddcutil} getvcp 10 \
        | awk -F 'current value = ' '{print $2}' \
        | awk -F',' '{print $1}' \
        | grep '[0-9]' \
        | sed 's/[^0-9]//g' \
        > /tmp/previous_brightness
      for bus in $(${ddcutil} detect --terse | grep -F "I2C bus:" | awk -F '-' '{print $2}'); do
        ${ddcutil} setvcp 10 $1 \
          --bus "$bus" \
          --mccs 2.2 \
          --sleep-multiplier 3 \
          --disable-dynamic-sleep
      done
    ''
  );

  git_clone_bare = pkgs.lib.getExe (
    pkgs.writeShellScriptBin "git_clone_bare" ''
      #!/usr/bin/env bash
      set -euo pipefail

      url=''${1:? "usage: clb <repo-url> [target-dir]"}

      # Derive dir name unless provided; works for https/ssh/scp-like URLs
      dir=''${2:-$(printf '%s' "$url" | sed -E 's#/$##; s#^.*[:/]+##; s#\.git$##')}

      mkdir -p "$dir"
      cd "$dir"

      # Bare clone into .git
      git clone --bare "$url" .git

      # 1) Prefer HEAD from the newly-cloned bare repo
      branch="$(git --git-dir=.git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
      if [ -z "''${branch:-}" ]; then
        # 2) Fallback: ask the remote where HEAD points
        branch="$(git ls-remote --symref "$url" HEAD 2>/dev/null \
                  | awk '/^ref:/ {print $3}' | sed 's#^refs/heads/##' || true)"
      fi
      # 3) Fallbacks: main → master → first head found
      if [ -z "''${branch:-}" ] && git --git-dir=.git show-ref --verify --quiet "refs/heads/main"; then
        branch=main
      fi
      if [ -z "''${branch:-}" ] && git --git-dir=.git show-ref --verify --quiet "refs/heads/master"; then
        branch=master
      fi
      if [ -z "''${branch:-}" ]; then
        branch="$(git --git-dir=.git show-ref | awk '/refs\/heads\// {sub(/^.*refs\/heads\//,"",$2); print $2; exit}')"
      fi

      if [ -z "''${branch:-}" ]; then
        echo "Could not detect a default branch (tried .git/HEAD, origin/HEAD, main, master)." >&2
        exit 1
      fi

      # In a bare clone, branches are in refs/heads/*, not refs/remotes/*
      git --git-dir=.git worktree add -B "$branch" "$branch" "$branch"

      echo "✓ Created bare repo in $(pwd)/.git and worktree in $(pwd)/$branch (branch: $branch)"
    ''
  );

  inherit reload_configs;
}
