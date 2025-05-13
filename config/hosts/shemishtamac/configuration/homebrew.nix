{ inputs, host, ... }:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
  nix-homebrew = {
    enable = true;
    user = builtins.elemAt (builtins.attrNames host.users) 0;
  };
  homebrew = {
    enable = true;
    casks = [
      {
        name = "zen-browser";
        link = true;
      }
    ];
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
    };
  };
}
