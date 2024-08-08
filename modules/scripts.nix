{ pkgs, ... }:

pkgs.writeShellScriptBin "reload" ''
    git -C $HOME/.config/nixos add .
    git commit -m 'update'
    sudo nixos-rebuild switch --flake . --show-trace \
        && home-manager switch --flake . --show-trace
    systemctl --user restart hyprpaper.service
''
