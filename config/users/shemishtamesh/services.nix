{ host, shared, ... }:
{
  services = (
    if (shared.functions.os host) == "linux" then
      {
        kdeconnect = {
          enable = true;
          indicator = true;
        };
      }
    else
      { }
  );
}
