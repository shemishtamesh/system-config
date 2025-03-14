{
  description = "nixos and home-manager config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
    nixvim.url = "github:shemishtamesh/nixvim-flake";
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    {
      inherit (import ./modules/profiles inputs) nixosConfigurations homeConfigurations;

      formatter = builtins.listToAttrs (
        map (system: {
          name = system;
          value =
            (treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} {
              projectRootFile = "flake.nix";
              programs.nixfmt.enable = true;
              settings.excludes = [
                "*.png"
                "*.lock"
              ];
            }).config.build.wrapper;
        }) [ "x86_64-linux" ]
      );
    };
}
