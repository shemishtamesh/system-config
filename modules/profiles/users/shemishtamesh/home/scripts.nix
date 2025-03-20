{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "rebuild" ''
      export FLAKE="$HOME/.config/system-flake"

      git -C $FLAKE add .
      git -C $FLAKE commit -m 'format'
      nix fmt $FLAKE

      if [ -z "$1" ] || [ "$1" == "os" ]; then
        git -C $FLAKE add .
        git -C $FLAKE commit -m 'rebuilding nixos'
        nh os switch $FLAKE
        if [ $? -ne 0 ] ; then
          git -C $FLAKE commit --amend -m 'nixos rebuild failed'
          git push
          ${pkgs.libnotify}/bin/notify-send -u critical 'nixos rebuild failed'
          exit 1
        fi
      fi

      if [ -z "$1" ] || [ "$1" == "home" ]; then
        git -C $FLAKE add .
        git -C $FLAKE commit -m 'rebuilding home'
        nix flake update nixvim --flake $FLAKE
        nh home switch $FLAKE
        if [ $? -ne 0 ] ; then
          git -C $FLAKE commit --amend -m 'home rebuild failed'
          git push
          ${pkgs.libnotify}/bin/notify-send -u critical 'home rebuild failed'
          exit 1
        fi
      fi

      git push

      systemctl --user restart hyprpaper.service
      if [ $? -ne 0 ] ; then
        ${pkgs.libnotify}/bin/notify-send -u critical 'wallpaper switch failed'
        exit 1
      fi

      ${pkgs.libnotify}/bin/notify-send -u low 'successfully rebuilt'
    '')

    (pkgs.writeShellScriptBin "bak" ''
      filename="$1"
      if [[ "$filename" =~ .bak$ ]]; then
          mv -i "$filename" "''${filename%.bak}";
          exit 0;
      else
          mv -i "$filename" "$filename.bak";
          exit 0;
      fi
      echo "Error: $filename is not a valid file or directory.";
      exit 1;
    '')
  ];
}
