{ inputs, host, ... }:
{
  # add the home manager module
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    configDir = ./source;
    extraPackages = [
      inputs.ags.packages.${host.system}.battery
      # pkgs.fzf
    ];
  };
}
