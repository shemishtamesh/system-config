inputs:
let
  hostname = "shenixtamesh";
  system = "x86_64-linux";
  monitors = {
    "eDP-1" = {
      width = 1920;
      height = 1080;
      refresh_rate = 60;
      horizontal_offset = 1920;
      vertical_offset = 0;
      scaling = 1;
    };
    "HDMI-A-1" = {
      width = 1920;
      height = 1080;
      refresh_rate = 60;
      horizontal_offset = 0;
      vertical_offset = 0;
      scaling = 1;
    };
  };
  users = {
    shemishtamesh = {
      isNormalUser = true;
      description = "shemishtamesh"; # TODO: remove this
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "adbusers"
        "docker"
      ];
    };
  };
in
{
  nixosConfigurations = ((import ../../utils.nix) inputs).mkNixosSystem {
    inherit hostname system users;
  };
  homeConfigurations = builtins.foldl' (
    accumulator: file: accumulator // (import ../../users/${file}) { inherit inputs system; }
  ) { } (builtins.attrNames users);
}
