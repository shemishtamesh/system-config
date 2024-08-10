{
  description = "nixos and home-manager config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    stylix.url = "github:donovanglover/stylix";
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      theme = (import modules/utils/theming.nix { inherit pkgs; inherit lib; });
    in
    {
      nixosConfigurations.shenixtamesh = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; inherit theme; };
        modules = [
          ./modules/nixos/configuration.nix
          stylix.nixosModules.stylix
        ];
      };
      homeConfigurations.shemishtamesh = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs; inherit theme; };
        inherit pkgs;
        modules = [
          ./modules/home-manager/home.nix
          stylix.homeManagerModules.stylix
        ];
      };
    };
}
