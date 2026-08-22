inputs:
let
  per_system = inputs.nixpkgs.lib.genAttrs (map (host: host.system) (import ../. inputs).hosts);
in
{
  formatter = builtins.listToAttrs (
    map (system: {
      name = system;
      value =
        (inputs.treefmt-nix.lib.evalModule inputs.nixpkgs.legacyPackages.${system} {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
          settings.excludes = [
            "*.png"
            "*.lock"
          ];
        }).config.build.wrapper;
    }) inputs.nixpkgs.lib.systems.doubles.all
  );
  apps = per_system (
    system:
    let
      FLAKE_ROOT = (import ./constants.nix pkgs).FLAKE_ROOT;
      FLAKE_REPO = (import ./constants.nix pkgs).FLAKE_REPO;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      shared = import ./default.nix pkgs;
      inherit (inputs.nixpkgs) lib;
      kernel = lib.last (lib.splitString "-" system);
      os_specific =
        if kernel == "linux" then
          {
            os_switch_command = # sh
              ''nh os switch "$NH_FLAKE"'';
            notify_os_switch_failure = # sh
              "notify-send -u critical 'nixos switch failed'";
            notify_home_switch_failure = # sh
              "notify-send -u critical 'home switch failed'";
            notify_switch_success = # sh
              "notify-send -u low 'switch succeeded'";
          }
        else if kernel == "darwin" then
          {
            os_switch_command = # sh
              ''sudo darwin-rebuild switch --flake "$NH_FLAKE"'';
            notify_os_switch_failure = # sh
              "terminal-notifier -message 'nix-darwin switch failed'";
            notify_home_switch_failure = # sh
              "terminal-notifier -message 'home switch failed'";
            notify_switch_success = # sh
              "terminal-notifier -message 'switch succeeded'";
          }
        else
          throw "unknown system type";
      runtimeInputs =
        with pkgs;
        [
          git
          nh
          nvd
          nix-output-monitor
          ssh-to-age
          fastfetch
        ]
        ++ (if kernel == "darwin" then [ pkgs.terminal-notifier ] else [ libnotify ]);
    in
    {
      default = inputs.self.apps.${system}.switch;
      switch = {
        type = "app";
        program = inputs.nixpkgs.lib.getExe (
          pkgs.writeShellApplication {
            name = "switch";
            inherit runtimeInputs;
            text =
              # sh
              ''
                generate_commit_message() {
                  fallback="$1"
                  message=""
                  if command -v ollama > /dev/null 2>&1 && ollama list 2>/dev/null | grep -q 'qwen2.5-coder:7b'; then
                    diff="$(git -C "$NH_FLAKE" diff HEAD)"
                    if [ -n "$diff" ]; then
                      commit_instructions="$(
                        printf '%s' \
                          'Write a Conventional Commits git commit message for the diff below: ' \
                          'a short imperative title line in the form "type(scope): summary" ' \
                          '(max 72 characters), then a blank line, then one or more concise ' \
                          'body lines describing what changed and why if evident. ' \
                          'Your entire response must be ONLY the commit message text itself - ' \
                          'no preamble, no explanation, no markdown code fences, no surrounding quotes.'
                      )"
                      prompt="$(printf '%s\n\nDiff:\n%s' "$commit_instructions" "$diff")"
                      message="$(
                        printf '%s' "$prompt" \
                          | ollama run --nowordwrap qwen2.5-coder:7b 2>/dev/null \
                          | sed '/^```/d' \
                          | sed -e '/./,$!d' -e :a -e '/^\n*$/{$d;N;ba' -e '}' \
                          || true
                      )"
                    fi
                  fi
                  if [ -n "$message" ]; then
                    echo "$message"
                  else
                    echo "$fallback"
                  fi
                }

                if [ -f "$HOME/.ssh/id_ed25519" ] && [ ! -f "$HOME/.config/sops/age/key.txt" ]; then
                  cp "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ed25519.bak"
                  ssh-keygen -p -N "" -f "$HOME/.ssh/id_ed25519" -C "temp-for-sops"
                  mkdir -p "$HOME/.config/sops/age/"
                  ssh-to-age -private-key -i "$HOME/.ssh/id_ed25519" > "$HOME/.config/sops/age/key.txt"
                  mv "$HOME/.ssh/id_ed25519.bak" "$HOME/.ssh/id_ed25519"
                fi

                git -C "$NH_FLAKE" pull

                git rebase --autostash > /dev/null
                nix fmt "$NH_FLAKE"
                echo 'formatted'

                if [ -z "''${2-}" ]; then
                    nix flake update nixvim --flake "$NH_FLAKE"
                    nix flake update secrets --flake "$NH_FLAKE"
                    echo 'updated flakes'
                fi

                if [[ -z "''${1-}" || "$1" == "os" ]]; then
                  if ! ${os_specific.os_switch_command}; then
                    ${os_specific.notify_os_switch_failure}
                    exit 1
                  fi
                  echo 'updated os'
                fi

                if [[ -z "''${1-}" || "$1" == "home" ]]; then
                  if ! nh home switch "$NH_FLAKE" --backup-extension bak; then
                    ${os_specific.notify_home_switch_failure}
                    exit 1
                  fi
                  echo 'updated home'
                  ${shared.scripts.reload_configs}
                fi

                git -C "$NH_FLAKE" add .
                if ! git -C "$NH_FLAKE" diff --cached --quiet; then
                  git -C "$NH_FLAKE" commit -m "$(generate_commit_message 'system switch succeeded')" > /dev/null
                fi

                git push > /dev/null

                ${os_specific.notify_switch_success}
                echo 'switch successful'
                fastfetch --logo none
              '';
          }
        );
      };
      install = {
        type = "app";
        program = inputs.nixpkgs.lib.getExe (
          pkgs.writeShellApplication {
            name = "install";
            inherit runtimeInputs;
            text =
              # sh
              ''
                export NH_FLAKE="${FLAKE_ROOT}"
                git clone ${FLAKE_REPO} $NH_FLAKE
                starting_commit=$(git -C "$NH_FLAKE" rev-parse HEAD)

                hostname="$1"
                username="$2"

                nixos-generate-config --show-hardware-config > $NH_FLAKE/config/hosts/"$hostname"/configuration/generated_hardware_configuration.nix

                ${os_specific.os_switch_command}
                nh home switch "$NH_FLAKE#$username@$hostname" --backup-extension bak

                git push

                ${os_specific.notify_switch_success}
                ${pkgs.fastfetch}/bin/fastfetch
              '';
          }
        );
      };
      offline_switch = {
        type = "app";
        program = inputs.nixpkgs.lib.getExe (
          pkgs.writeShellApplication {
            name = "offline_switch";
            text = # sh
              "sudo nixos-rebuild switch --flake . --option substitute false";
          }
        );
      };
      time_from_update = {
        type = "app";
        program = inputs.nixpkgs.lib.getExe (
          pkgs.writeShellApplication {
            name = "time_from_update";
            text = # sh
              ''
                last_update="$(${lib.getExe pkgs.jq} -r '.nodes.nixpkgs.locked.lastModified' "$FLAKE/flake.lock")"
                current_time="$(date +%s)"
                readable_last_update=$(date -u -d @"$last_update")
                echo "last update was at $readable_last_update"
                readable_range=$(date -u -d @$((current_time - last_update)) +"%d days, %H hours, %M minutes, and %S seconds")
                echo "time since last update is $readable_range"
              '';
          }
        );
      };
    }
  );
}
