{
  nixpkgs,
  nix-darwin,
  nix-on-droid,
  home-manager,
  sops-nix,
  stylix,
  hyprland,
  ...
}@inputs:
let
  pkgs = system: nixpkgs.legacyPackages.${system};
  shared = system: import ./. (pkgs system);
  stable-pkgs =
    host:
    import inputs.nixpkgs-stable {
      inherit (host) system;
      config = (shared host.system).nixpkgs_config;
    };

  mkHomeConfiguration =
    {
      username,
      host,
      home_modules,
    }:
    {
      "${username}@${host.hostname}" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          shared = shared host.system;
          stable-pkgs = stable-pkgs host;
          inherit
            inputs
            host
            username
            ;
        };
        pkgs = pkgs host.system;
        modules = [
          ../users/${username}

          sops-nix.homeManagerModules.sops
          ./sops_config.nix

          stylix.homeModules.stylix
        ]
        ++ home_modules;
      };
    };

  mkSystem =
    {
      system_type,
      modules ? [ ],
    }:
    host:
    let
      type_specific =
        if system_type == "nixos" then
          {
            attribute_name = "nixosConfigurations";
            config_maker = nixpkgs.lib.nixosSystem;
            modules = modules ++ [
              sops-nix.nixosModules.sops
              ./sops_config.nix

              stylix.nixosModules.stylix

              {
                networking.hostName = host.hostname;
                users.users = host.users;
              }
            ];
            home_modules = [ ];
          }

        else if system_type == "darwin" then
          {
            attribute_name = "darwinConfigurations";
            config_maker = nix-darwin.lib.darwinSystem;
            modules = modules ++ [
              sops-nix.darwinModules.sops
              ./sops_config.nix

              stylix.darwinModules.stylix

              {
                networking.hostName = host.hostname;
                users.users = host.users;
              }
            ];
            home_modules = [ ];
          }

        else if system_type == "nix-on-droid" then
          {
            attribute_name = "nixOnDroidConfigurations";
            config_maker = nix-on-droid.lib.nixOnDroidConfiguration;
            modules = modules ++ [ stylix.nixOnDroidModules.stylix ];
            home_modules = [ ];
          }

        else
          throw "unknown system type";
    in
    {
      ${type_specific.attribute_name}.${host.hostname} = type_specific.config_maker (
        {
          modules = [
            ../hosts/${host.hostname}/configuration
          ]
          ++ type_specific.modules;
        }
        // (
          if system_type == "nix-on-droid" then
            {
              pkgs = pkgs host.system;
            }
          else
            {
              specialArgs = {
                shared = shared host.system;
                stable-pkgs = stable-pkgs host;
                inherit
                  inputs
                  host
                  ;
              };
            }
        )
      );

      homeConfigurations = builtins.foldl' (
        accumulator: username:
        inputs.nixpkgs.lib.attrsets.recursiveUpdate accumulator (mkHomeConfiguration {
          inherit username host;
          inherit (type_specific) home_modules;
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
  };
  mkNixOnDroidConfiguration = mkSystem {
    system_type = "nix-on-droid";
  };
}
