profile_makers:
let
  host = {
    hostname = "shemishtamac";
    system = "aarch64-darwin";
    users = {
      shemishtamesh = {
        # isNormalUser = true;
      };
    };
    monitors = { };
  };
in
profile_makers.mkDarwinSystem host
