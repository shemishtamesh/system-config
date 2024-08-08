{ pkgs, ... }:

let
  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    git -C $HOME/.config/nixos add .
    git commit -m 'update'
    sudo nixos-rebuild switch --flake . --show-trace \
        && home-manager switch --flake . --show-trace
    systemctl --user restart hyprpaper.service
    notify-send 'done rebuilding'
  '';
in
{
  environment.systemPackages = [ rebuild ];
}
