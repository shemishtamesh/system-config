{ inputs, system }:
let
  username = "shemishtamesh";

  utils = (import ../../utils.nix) inputs;
in
utils.mkHomeConfiguration {
  inherit system username;
}
