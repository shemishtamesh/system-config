profile_makers:
let
  host = {
    hostname = "shemishtamac";
    system = "aarch64-darwin";
    users.shemishtamesh = { };
    # monitors = { };
  };
in
profile_makers.mkDarwinSystem host
