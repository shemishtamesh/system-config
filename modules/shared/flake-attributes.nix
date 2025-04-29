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
      FLAKE_ROOT = "$HOME/.config/system-flake";
      FLAKE_REPO = "https://github.com/shemishtamesh/system-flake.git";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      lib = inputs.nixpkgs.lib;
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
              ''darwin-rebuild switch --flake "$NH_FLAKE"'';
            notify_os_switch_failure = # sh
              "terminal-notifier -message 'nix-darwin switch failed'";
            notify_home_switch_failure = # sh
              "terminal-notifier -message 'home switch failed'";
            notify_switch_success = # sh
              "terminal-notifier -message 'switch succeeded'";
            update_wallpaper = "";
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
                export NH_FLAKE="${FLAKE_ROOT}"
                starting_commit=$(git -C "$NH_FLAKE" rev-parse HEAD)

                git -C "$NH_FLAKE" add .
                git -C "$NH_FLAKE" commit -m 'before formatting' > /dev/null || true
                nix fmt "$NH_FLAKE"
                echo 'formatted'

                git -C "$NH_FLAKE" add .
                nix flake update nixvim --flake "$NH_FLAKE"
                git -C "$NH_FLAKE" commit -am 'updating flakes' > /dev/null || true
                echo 'updated flakes'

                if [[ -z "''${1-}" || "$1" == "os" ]]; then
                  git -C "$NH_FLAKE" commit -am 'switching os confg' > /dev/null || true
                  if ! ${os_specific.os_switch_command}; then
                    git -C "$NH_FLAKE" commit --amend -am 'os config switch failed' > /dev/null
                    git push > /dev/null
                    ${os_specific.notify_os_switch_failure}
                    exit 1
                  fi
                  echo 'updated os'
                fi

                if [[ -z "''${1-}" || "$1" == "home" ]]; then
                  git -C "$NH_FLAKE" commit -am 'switch home config' > /dev/null || true
                  if ! nh home switch "$NH_FLAKE" --backup-extension bak; then
                    git -C "$NH_FLAKE" commit --amend -m 'home config switch failed' > /dev/null
                    git push > /dev/null
                    ${os_specific.notify_home_switch_failure}
                    exit 1
                  fi
                  echo 'updated home'
                fi

                if [[ -z "''${1-}" && "$starting_commit" != "$(git -C "$NH_FLAKE" rev-parse HEAD)" ]]; then
                  git -C "$NH_FLAKE" commit --amend -m 'system switch succeeded' > /dev/null
                fi

                git push > /dev/null

                ${os_specific.update_wallpaper}
                echo 'updated wallpaper'

                ${os_specific.notify_switch_success}
                echo 'switch successful'
                ${pkgs.fastfetch}/bin/fastfetch
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

                nixos-generate-config --show-hardware-config > $NH_FLAKE/modules/hosts/"$hostname"/configuration/generated_hardware_configuration.nix

                ${os_specific.os_switch_command}
                nh home switch "$NH_FLAKE#$username@$hostname" --backup-extension bak

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
