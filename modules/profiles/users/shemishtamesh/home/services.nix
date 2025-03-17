{ host, ... }:
{
  services = {
    kdeconnect =
      if (host.system == "x86_64-linux") || (host.system == "aarch64-linux") then
        {
          enable = true;
          indicator = true;
        }
      else
        { };
  };
}
