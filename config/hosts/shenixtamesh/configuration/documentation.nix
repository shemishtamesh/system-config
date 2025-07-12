{ pkgs, ... }:

{
  # environment.systemPackages = [ pkgs.man-pages ];

  documentation = {
    # dev.enable = true;
    man.generateCaches = true;
    # nixos.includeAllModules = true;
  };
}
