{
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      keymap_mode = "vim-insert";
      keymap_cursor = {
        vim_insert = "blink-bar";
        vim_normal = "steady-block";
      };
      enter_accept = true;
    };
    daemon = {
      enable = true;
      socket_path = "~/.local/share/atuin/atuin.sock";
    };
  };
}
