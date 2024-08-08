{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-colors.url = "github:misterio77/nix-colors";
    stylix = {
      url = "github:donovanglover/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.shenixtamesh = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          inputs.stylix.nixosModules.stylix
        ];
      };
      homeConfigurations.shemishtamesh = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs; };
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
