{
  inputs,
  host,
  ...
}:
{
  # add the home manager module
  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    configDir = ./source;
    extraPackages =
      (with inputs.ags.packages.${host.system}; [
        io
        astal4

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
      ]);
  };
}
