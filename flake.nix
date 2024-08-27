{
  description = "nixos and home-manager config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    zen-browser.url = "github:MarceColl/zen-browser-flake";

    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      theme = (import modules/general/theming.nix { inherit pkgs; });
    in
    {
      nixosConfigurations.shenixtamesh = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; inherit theme; inherit system;};
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
