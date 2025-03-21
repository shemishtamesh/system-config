inputs:
let
  hostnames = [
    "shenixtamesh"
    "shemishtamac"
  ];
in
builtins.foldl' (
  accumulator: module:
  inputs.nixpkgs.lib.attrsets.recursiveUpdate accumulator (
    (import module) (import ./shared/profile_makers.nix inputs)
  )
) { } (map (name: ./hosts/${name}) hostnames)
