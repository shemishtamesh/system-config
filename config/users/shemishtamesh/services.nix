{ host, shared, ... }:
{
  services = (
    if (shared.os host) == "linux" then
      {
        kdeconnect = {
          enable = true;
          indicator = true;
        };
        gnome.evolution-data-server.enable = true;
      }
    else
      { }
  );
}
