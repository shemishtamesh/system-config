inputs:
builtins.listToAttrs (
  map (system: {
    name = system;
    value =
      (inputs.treefmt-nix.lib.evalModule inputs.nixpkgs.legacyPackages.${system} {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        settings.excludes = [
          "*.png"
          "*.lock"
        ];
      }).config.build.wrapper;
  }) inputs.nixpkgs.lib.systems.doubles.all
)
