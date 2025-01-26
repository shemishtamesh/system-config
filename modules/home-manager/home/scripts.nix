{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "rebuild" ''
      FLAKE="$HOME/.config/flake"

      ${pkgs.nixfmt-rfc-style}/bin/nixfmt $FLAKE

      if [ -z "$1" ] || [ "$1" == "os" ]; then
        git -C $FLAKE add .
        git -C $FLAKE commit -m 'rebuilding nixos'
        nh os switch $FLAKE
        if [ $? -ne 0 ] ; then
          git -C $FLAKE commit --amend -m 'nixos rebuild failed'
          notify-send -u critical 'nixos rebuild failed'
          exit 1
        fi
      fi

      if [ -z "$1" ] || [ "$1" == "home" ]; then
        git -C $FLAKE add .
        git -C $FLAKE commit -m 'rebuilding home'
        nh home switch $FLAKE
        if [ $? -ne 0 ] ; then
          git -C $FLAKE commit -m 'home rebuild failed'
          notify-send -u critical 'home rebuild failed'
          exit 1
        fi
      fi

      systemctl --user restart hyprpaper.service
      if [ $? -ne 0 ] ; then
        notify-send -u critical 'wallpaper switch failed'
        exit 1
      fi

      git push

      notify-send -u low 'successfully rebuilt'
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
