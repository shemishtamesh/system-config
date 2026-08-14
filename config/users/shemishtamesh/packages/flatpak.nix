{ config, ... }:
{
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    packages = [
      "org.vinegarhq.Sober"
    ];
    overrides.settings."org.vinegarhq.Sober".Context.devices = [ "all" ];
  };

  xdg.systemDirs.data = [
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
    "/var/lib/flatpak/exports/share"
  ];
}
