{
  programs.starship = {
    enable = true;
    settings = {
      nix_shell.heuristic = true; # https://github.com/starship/starship/pull/4724#pullrequestreview-1222025226
      shlvl.disabled = false;
    };
  };
}
