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
      "zen-browser"
      "tableau"
    ];
    onActivation = {
      # cleanup = "uninstall"; # WARNING: would be preferable, but seems to cause brew to uninstall everything (even if listed here), and then install it in the next rebuild
      autoUpdate = true;
    };
  };
}
