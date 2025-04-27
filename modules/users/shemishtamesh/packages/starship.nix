{
  programs.starship = {
    enable = true;
    settings = {
      nix_shell.huristics = true; # https://github.com/starship/starship/pull/4724#pullrequestreview-1222025226
    };
  };
}
