{ pkgs }:

pkgs.writeShellScriptBin "reload" ''
    git add .
    git commit -m 'update'
    sudo nixos-rebuild switch --flake . --show-trace \
        && home-manager switch --flake . --show-trace
''
