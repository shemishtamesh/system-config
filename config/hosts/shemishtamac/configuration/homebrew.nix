{ inputs, host, ... }:
let
  taps = {
    "homebrew/homebrew-core" = "inputs.homebrew-core";
    # this is a set instead of a list temporarily, until the issue with having bloodhound.rb is resolved
    "homebrew/homebrew-cask" = "inputs.homebrew-cask";
  };
in
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];
  nix-homebrew = {
    enable = true;
    user = builtins.elemAt (builtins.attrNames host.users) 0;
    # inherit taps;
    # mutableTaps = false;
  };
  homebrew = {
    enable = true;
    casks = [ "zen-browser" ];
    onActivation.cleanup = "uninstall";
    taps = builtins.attrNames taps;
  };
}
