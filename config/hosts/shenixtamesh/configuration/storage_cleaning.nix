{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
    };
    settings.auto-optimise-store = true;
  };
}
