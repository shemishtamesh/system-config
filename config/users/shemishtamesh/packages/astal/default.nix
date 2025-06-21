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
    extraPackages = (
      with inputs.ags.packages.${host.system};
      [
        hyprland
        network
        powerprofiles
        wireplumber
        battery
        bluetooth
        notifd
        astal4
        astal3
        mpris
        greet
        river
        auth
        tray
        apps
        cava
        gjs
        io
      ]
    );
  };
}
