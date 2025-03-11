{
  username,
  host,
  inputs,
}:
let
  utils = (import ../../utils.nix) inputs;
in
utils.mkHomeConfiguration {
  inherit username host;
}
