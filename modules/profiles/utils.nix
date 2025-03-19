{
  nixpkgs,
  nix-darwin,
  home-manager,
  stylix,
  hyprland,
  mac-app-util,
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
    }@host:
    {
      ${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          shared = shared system;
          inherit
            inputs
            host
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
  mkDarwinSystem =
    {
      system,
      hostname,
      ...
    }@host:
    {
      ${hostname} = nix-darwin.lib.darwinSystem {
        specialArgs = {
          shared = shared system;
          inherit
            inputs
            host
            ;
        };
        modules = [
          ./hosts/${hostname}/configuration
          stylix.darwinModules.stylix
          mac-app-util.darwinModules.default
        ];
      };
    };
  mkHomeConfiguration =
    { username, host }:
    with host;
    {
      "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          shared = shared system;
          inherit inputs host username;
        };
        pkgs = pkgs system;
        modules = [
          ./users/${username}/home
          stylix.homeManagerModules.stylix
          hyprland.homeManagerModules.default
          mac-app-util.homeManagerModules.default
        ];
      };
    };
}
