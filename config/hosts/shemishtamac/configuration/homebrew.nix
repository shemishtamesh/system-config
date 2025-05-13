{ inputs, host, ... }:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
  nix-homebrew = {
    enable = true;
    user = builtins.elemAt (builtins.attrNames host.users) 0;
  };
  homebrew = {
    enable = true;
    casks = [ "zen-browser" ];
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
    };
  };
}
