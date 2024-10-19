{
  programs.nixvim.plugins.zen-mode = {
    enable = true;
    settings = {
      window = {
        backdrop = 1;
        width = 80;
        height = 1;
        options = {
          signcolumn = "no";
          number = false;
          relativenumber = false;
          foldcolumn = "0";
          list = false;
        };
      };
    };
  };
}
