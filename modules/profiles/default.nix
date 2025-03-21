inputs:
let
  hostnames = [
    "shenixtamesh"
    "shemishtamac"
  ];
in
builtins.foldl' (
  accumulator: module:
  inputs.nixpkgs.lib.attrsets.recursiveUpdate accumulator ((import module) inputs)
) { } (map (name: ./hosts/${name}) hostnames)
