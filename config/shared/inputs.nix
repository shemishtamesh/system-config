let
  follows =
    inputs_to_follow:
    builtins.mapAttrs (
      name: url:
      {
        inherit url;
      }
      // builtins.foldl' (accumilating: attrs: accumilating // attrs) { } (
        map (input_name: {
          inputs.${input_name}.follows = input_name;
        }) inputs_to_follow
      )
    );
in
{
  nixpkgs.url = "nixpkgs/nixos-unstable";
}
// follows [ "nixpkgs" ] {
  nix-index-database = "github:nix-community/nix-index-database";
  home-manager = "github:nix-community/home-manager";
  nix-on-droid = "github:nix-community/nix-on-droid/master";
  nix-darwin = "github:LnL7/nix-darwin/master";
  nix-homebrew = "github:zhaofengli/nix-homebrew";
  mac-app-util = "github:hraban/mac-app-util";
  hyprland.url = "github:hyprwm/Hyprland";
  nixvim = "github:shemishtamesh/nixvim-flake";
  zen-browser = "github:0xc000022070/zen-browser-flake";
  nixcord = "github:kaylorben/nixcord";
  spicetify-nix = "github:Gerg-L/spicetify-nix";
  stylix = "github:danth/stylix";
  treefmt-nix = "github:numtide/treefmt-nix";
}
