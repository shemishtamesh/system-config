profile_makers:
profile_makers.mkDarwinSystem {
  hostname = "shemishtamac";
  system = "aarch64-darwin";
  users.shemishtamesh = { };
  monitors = {
    "BUILTIN" = {
      width = 3456;
      height = 2234;
    };
  };
}
