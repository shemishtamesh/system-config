{
  nixpkgs,
  home-manager,
  stylix,
  hyprland,
  ...
}@inputs:
let
  pkgs = system: nixpkgs.legacyPackages.${system};
  shared = system: import ../shared (pkgs system);
in
{
  mkNixosSystem =
    {
      system,
      hostname,
      users,
      ...
    }:
    {
      ${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          shared = shared system;
          inherit
            inputs
            hostname
            ;
        };
        modules = [
          ./hosts/${hostname}/configuration
          stylix.nixosModules.stylix
          hyprland.nixosModules.default
          {
            networking.hostName = hostname;
            users.users = users;
          }
        ];
      };
    };
  mkHomeConfiguration =
    { system, username }:
    {
      shared_test = shared system;
      pkgs = pkgs system;
      ${username} = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          shared = shared system;
          inherit inputs;
        };
        pkgs = pkgs system;
        modules = [
          ./users/${username}/home
          stylix.homeManagerModules.stylix
          hyprland.homeManagerModules.default
        ];
      };
    };
}
