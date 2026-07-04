{ openrouterKeyEnvVar ? "OPENROUTER_API_KEY" }:
let
  readOnlyBash = import ./read-only-bash.nix;
  sensitivePaths = import ./sensitive-paths.nix;
  providers = import ./providers.nix { inherit openrouterKeyEnvVar; };
in
  readOnlyBash // sensitivePaths // { inherit providers; }
