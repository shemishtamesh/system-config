{ pkgs, ... }:
{
  systemd.user.services.transmission-daemon = {
    Unit = {
      Description = "transmission bittorrent daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.transmission_4-gtk}/bin/transmission-daemon --foreground";
      Restart = "always";
      RestartSec = 1;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
