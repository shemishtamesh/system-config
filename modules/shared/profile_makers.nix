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
  shared = system: import ./. (pkgs system);
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
          ../users/${username}
          stylix.homeManagerModules.stylix
          hyprland.homeManagerModules.default
          mac-app-util.homeManagerModules.default
        ];
      };
    };
  mkSystem =
    {
      system_type,
      modules,
    }:
    host:
    let
      type_specific =
        if system_type == "nixos" then
          {
            attribute_name = "nixosConfigurations";
            config_maker = nixpkgs.lib.nixosSystem;
            stylix_module = stylix.nixosModules.stylix;
          }
        else if system_type == "darwin" then
          {
            attribute_name = "darwinConfigurations";
            config_maker = nix-darwin.lib.darwinSystem;
            stylix_module = stylix.darwinModules.stylix;
          }
        else
          throw "Unknown system type";
    in
    {
      ${type_specific.attribute_name}.${host.hostname} = type_specific.config_maker {
        specialArgs = {
          shared = shared host.system;
          inherit
            inputs
            host
            ;
        };
        modules = [
          ../hosts/${host.hostname}/configuration
          type_specific.stylix_module
          {
            networking.hostName = host.hostname;
            users.users = host.users;
          }
        ] ++ modules;
      };
      homeConfigurations = builtins.foldl' (
        accumulator: username:
        inputs.nixpkgs.lib.attrsets.recursiveUpdate accumulator (mkHomeConfiguration {
          inherit username host;
        })
      ) { } (builtins.attrNames host.users);
      hosts = [ host ];
    };
in
{
  mkNixosSystem = mkSystem {
    system_type = "nixos";
    modules = [
      hyprland.nixosModules.default
    ];
  };
  mkDarwinSystem = mkSystem {
    system_type = "darwin";
    modules = [
      mac-app-util.darwinModules.default
    ];
  };
}
