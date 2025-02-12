{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = "weekly";
    };
    settings.auto-optimise-store = true;
  };
}
