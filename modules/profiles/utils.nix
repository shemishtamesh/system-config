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
  mkDarwinSystem =
    {
      system,
      hostname,
      ...
    }:
    {
      ${hostname} = nix-darwin.lib.darwinSystem {
        specialArgs = {
          shared = shared system;
          inherit
            inputs
            hostname
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
    {
      "${username}@${host.hostname}" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          shared = shared host.system;
          inherit inputs host username;
        };
        pkgs = pkgs host.system;
        modules = [
          ./users/${username}/home
          stylix.homeManagerModules.stylix
          hyprland.homeManagerModules.default
          mac-app-util.homeManagerModules.default
        ];
      };
    };
}
