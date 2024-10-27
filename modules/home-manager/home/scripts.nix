{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "rebuild" ''
      FLAKE="$HOME/.config/flake"

      ${pkgs.nixfmt-rfc-style}/bin/nixfmt $FLAKE

      git -C $FLAKE add .
      git -C $FLAKE commit -m 'rebuilding nixos'
      nh os switch $FLAKE
      if [ $? -ne 0 ] ; then
        notify-send -u critical 'nixos rebuild failed'
        exit 1
      fi

      git -C $FLAKE add .
      git -C $FLAKE commit -m 'rebuilding home'
      nh home switch $FLAKE
      if [ $? -ne 0 ] ; then
        notify-send -u critical 'home rebuild failed'
        exit 1
      fi

      systemctl --user restart hyprpaper.service
      if [ $? -ne 0 ] ; then
        notify-send -u critical 'wallpaper switch failed'
        exit 1
      fi

      notify-send -u low 'rebuild succeed'
    '')

    (pkgs.writeShellScriptBin "bak" ''
      filename="$1"
      if [[ "$filename" =~ .bak$ ]]; then
          mv "$filename" "''${filename%.bak}";
          exit 0;
      else
          mv "$filename" "$filename.bak";
          exit 0;
      fi
      echo "Error: $filename is not a valid file or directory.";
      exit 1;
    '')
  ];
}
