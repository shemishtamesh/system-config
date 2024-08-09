{ pkgs, ... }:

let
  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    flake_path="$HOME/.config/flake"
    git -C $flake_path add .
    git -C $flake_path add .
    git -C $flake_path commit -m 'update'
    sudo nixos-rebuild switch --flake $flake_path --show-trace \
        && home-manager switch --flake $flake_path --show-trace
    systemctl --user restart hyprpaper.service
    notify-send 'done rebuilding'
  '';
in
{
  environment.systemPackages = [ rebuild ];
}
