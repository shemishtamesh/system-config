inputs:
let
  hosts = [
    "shenixtamesh"
    "shemishtamac"
  ];
in
builtins.foldl' (accumulator: module: accumulator // (import module) inputs) { } (
  map (name: ./hosts/${name}) hosts
)
