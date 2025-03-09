inputs:
let
  hostname = "shenixtamesh";
  system = "x86_64-linux";
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
