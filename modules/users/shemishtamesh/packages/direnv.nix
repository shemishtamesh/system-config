{
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh.initContent = # sh
      ''
        # ensure compatibility tmux <-> direnv
        if [ -n "$TMUX" ] && [ -n "$DIRENV_DIR" ]; then
            unset -m "DIRENV_*"  # unset env vars starting with DIRENV_
        fi
      '';
  };
}
