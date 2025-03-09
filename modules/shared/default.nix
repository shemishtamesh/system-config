pkgs:
let
  import_modules =
    module_names:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = import ./${name}.nix pkgs;
      }) module_names
    );
in
import_modules [
  "theme"
  "utils"
]
