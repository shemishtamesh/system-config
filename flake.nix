{
  description = "nixos and home-manager config flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nixvim.url = "github:shemishtamesh/nixvim-flake";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    stylix.url = "github:danth/stylix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs:
    let
      profiles = import ./modules/profiles inputs;
    in
    {
      inherit (profiles)
        nixosConfigurations
        darwinConfigurations
        homeConfigurations
        ;

      formatter = (import ./modules/shared/formatter.nix inputs);

      apps = map (system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
        in
        {
          type = "app";
          program = pkgs.writeShellScriptBin "switch" ''
            echo test
          '';
        }) profiles.hosts;
    };
}
