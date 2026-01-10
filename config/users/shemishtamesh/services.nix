{ shared, ... }:
{
  services = {
    ssh-agent = {
      enable = true;
    };
  }
  // (
    if shared.constants.OS == "linux" then
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
