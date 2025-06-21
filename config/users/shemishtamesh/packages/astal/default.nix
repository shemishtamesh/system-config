{ inputs, host, ... }:
{
  # add the home manager module
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    configDir = ./source;
    extraPackages = [
      inputs.ags.packages.${host.system}.hyprland
      inputs.ags.packages.${host.system}.mpris
      inputs.ags.packages.${host.system}.battery
      inputs.ags.packages.${host.system}.wp
      inputs.ags.packages.${host.system}.network
      inputs.ags.packages.${host.system}.tray
      # pkgs.fzf
    ];
  };
}
