{ inputs, host, ... }:
{
  homebrew = {
    enable = true;
    brews = [ "zen-browser" ];
  };
  modules = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        user = builtins.elemAt (builtins.attrNames host.users) 0;
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };
        mutableTaps = false;
      };
    }
  ];
}
