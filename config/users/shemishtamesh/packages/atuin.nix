{
  programs = {
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        keymap_mode = "vim-insert";
        keymap_cursor = {
          vim_insert = "blink-bar";
          vim_normal = "steady-block";
        };
        enter_accept = true;
        style = "full";
        inline_height = 0;
      };
      daemon.enable = true;
    };

    fzf.historyWidget.command = "";
  };
}
