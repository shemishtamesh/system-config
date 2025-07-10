{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 21d";
    };
    optimise = {
      automatic = true;
    };
    settings.auto-optimise-store = true;
  };
}
