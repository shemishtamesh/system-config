{ config, ... }:
{
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    packages = [ ];
  };

  xdg.systemDirs.data = [
    "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
    "/var/lib/flatpak/exports/share"
  ];
}
