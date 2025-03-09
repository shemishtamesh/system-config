inputs:
let
  hosts = [
    "shenixtamesh"
  ];
in
builtins.foldl' (accumulator: module: accumulator // (import module) inputs) { } (
  map (name: ./hosts/${name}) hosts
)
