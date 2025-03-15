inputs:
let
  host = {
    hostname = "shemishtamac";
    system = "aarch64-darwin";
    users = { };
    monitors = { };
  };
in
{
  darwinConfigurations = ((import ../../utils.nix) inputs).mkDarwinSystem host;
  homeConfigurations = builtins.foldl' (
    accumulator: username:
    inputs.nixpkgs.lib.attrsets.recursiveUpdate accumulator (
      (import ../../users/${username}) {
        inherit username host inputs;
      }
    )
  ) { } (builtins.attrNames host.users);
}
