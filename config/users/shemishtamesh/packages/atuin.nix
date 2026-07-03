{
  programs = {
    atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
        "--disable-ctrl-r"
      ];
      settings = {
        keymap_mode = "vim-insert";
        keymap_cursor = {
          vim_insert = "blink-bar";
          vim_normal = "steady-block";
        };
        enter_accept = true;
      };
      daemon.enable = true;
    };
  };
}
