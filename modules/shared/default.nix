pkgs:
let
  import_modules =
    paths:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = import ./${path} pkgs;
      }) paths
    );
in
import_modules [
  ./theme.nix
  ./functions.nix
  ./scripts.nix
]
