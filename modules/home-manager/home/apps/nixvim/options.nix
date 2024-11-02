{
  programs.nixvim = {
    opts = {
      # show substitution preview
      inccommand = "split";

      # set gui colors for terminal
      termguicolors = true;

      # Do not save when switching buffers
      hidden = true;

      # Number of screen lines to keep above and below the cursor
      scrolloff = 8;

      # Better editor UI
      number = true;
      numberwidth = 1;
      relativenumber = true;

      # Better editing experience
      expandtab = true;
      smarttab = true;
      cindent = true;
      autoindent = true;
      wrap = false;
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = -1; # If negative, shiftwidth value is used
      list = true;
      listchars = "trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂";
      conceallevel = 2;
      foldlevel = 99999; # disable folding by default

      # Case insensitive searching UNLESS /C or capital in search
      ignorecase = true;
      smartcase = true;

      # Undo and backup options
      undofile = true;
      swapfile = false;
      backupdir = "/tmp/";
      directory = "/tmp/";
      undodir = "/tmp/";

      # Remember 100 items in commandline history
      history = 100;

      # Better buffer splitting
      splitright = true;
      splitbelow = true;

      # enable mouse support
      mouse = "a";
    };
  };
}
