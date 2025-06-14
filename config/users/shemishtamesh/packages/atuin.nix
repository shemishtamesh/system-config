{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    # flags = [ "--disable-up-arrow" ];
    settings = {
      keymap_mode = "vim-normal";
      keymap_cursor = {
        vim_insert = "blink-bar";
        vim_normal = "steady-block";
      };
    };
  };
}
