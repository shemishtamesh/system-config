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
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      lib = inputs.nixpkgs.lib;
      kernel = lib.last (lib.splitString "-" system);
    in
    {
      default = inputs.self.apps.${system}.switch;
      switch = {
        type = "app";
        program = inputs.nixpkgs.lib.getExe (
          pkgs.writeShellApplication {
            name = "switch";
            runtimeInputs =
              with pkgs;
              [
                git
                libnotify
                nh
                nvd
                nix-output-monitor
              ]
              ++ (if kernel == "darwin" then [ pkgs.terminal-notifier ] else [ ]);
            text =
              let
                FLAKE_ROOT = "$HOME/.config/system-flake";
                os_specific =
                  if kernel == "linux" then
                    {
                      os_switch_command = # sh
                        ''nh os switch "$FLAKE"'';
                      notify_os_switch_failure = # sh
                        "notify-send -u critical 'nixos switch failed'";
                      notify_home_switch_failure = # sh
                        "notify-send -u critical 'home switch failed'";
                      notify_switch_success = # sh
                        "notify-send -u low 'system switch succeeded'";
                      update_wallpaper = # sh
                        ''
                          if ! systemctl --user restart hyprpaper.service; then
                            notify-send -u critical 'wallpaper switch failed'
                            exit 1
                          fi
                        '';
                    }
                  else if kernel == "darwin" then
                    {
                      os_switch_command = # sh
                        ''darwin-rebuild switch --flake "$FLAKE"'';
                      notify_os_switch_failure = # sh
                        "terminal-notifier -message 'nix-darwin switch failed'";
                      notify_home_switch_failure = # sh
                        "terminal-notifier -message 'home switch failed'";
                      notify_switch_success = # sh
                        "notify-send -u critical 'system switch succeeded'";
                      update_wallpaper = "";
                    }
                  else
                    throw "unknown system type";
              in
              # sh
              ''
                export FLAKE="${FLAKE_ROOT}"

                git -C "$FLAKE" add .
                git -C "$FLAKE" commit -m 'before formatting' || true
                nix fmt "$FLAKE"

                if [[ -z "''${1-}" || "$1" == "os" ]]; then
                  git -C "$FLAKE" commit --amend -am 'switching nixos'
                  if ! ${os_specific.os_switch_command}; then
                    git -C "$FLAKE" commit --amend -am 'nixos switch failed'
                    git push
                    ${os_specific.notify_os_switch_failure}
                    exit 1
                  fi
                fi

                if [[ -z "''${1-}" || "$1" == "home" ]]; then
                  git -C "$FLAKE" commit --amend -am 'switch home'
                  nix flake update nixvim --flake "$FLAKE"
                  if ! nh home switch "$FLAKE" --backup-extension bak; then
                    git -C "$FLAKE" commit --amend -m 'home switch failed'
                    git push
                    ${os_specific.notify_home_switch_failure}
                    exit 1
                  fi
                fi

                if [[ -z "''${1-}" ]]; then
                  git -C "$FLAKE" commit --amend -m 'system switch succeeded'
                fi

                git push

                ${os_specific.update_wallpaper}

                ${os_specific.notify_switch_success}
              '';
          }
        );
      };
    }
  );
}
