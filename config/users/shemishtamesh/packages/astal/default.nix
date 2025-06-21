{ inputs, host, ... }:
{
  # add the home manager module
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    configDir = ./source;
    extraPackages = inputs.ags.packages.${host.system} [
      tray
      bluetooth
      network
      battery
      wireplumber
      hyprland
      notifd
      mpris
      powerprofiles
      apps
    ];
  };
}
