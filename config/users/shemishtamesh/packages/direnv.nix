{ stable-pkgs, ... }:
{
  programs = {
    direnv = {
      enable = true;
      package = stable-pkgs.direnv;
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };
    zsh.initContent = # sh
      ''
        # ensure compatibility between tmux and direnv
        if [ -n "$TMUX" ] && [ -n "$DIRENV_DIR" ]; then
            unset -m "DIRENV_*"  # unset env vars starting with DIRENV_
        fi
      '';
  };
}
