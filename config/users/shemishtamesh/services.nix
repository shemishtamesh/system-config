{ shared, ... }:
{
  services = (
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
