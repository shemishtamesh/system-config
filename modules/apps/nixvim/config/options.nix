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
      # signcolumn = "yes";
      # cursorline = false;
      # t.cmdheight = 0;
  
      # Better editing experience
      expandtab = true;
      smarttab = true;
      cindent = true;
      autoindent = true;
      wrap = false;
      # textwidth = 300;
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = -1; # If negative, shiftwidth value is used
      list = true;
      listchars = "trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂";
      # listchars = "eol:¬,space:·,lead: ,trail:·,nbsp:◇,tab:→-,extends:▸,precedes:◂,multispace:···⬝,leadmultispace:│   ,";
      # formatoptions = "qrn1";
      conceallevel = 2;
  
      # color the 80th color, a hint for when a line is too long
      colorcolumn = "80";
  
      # Case insensitive searching UNLESS /C or capital in search
      ignorecase = true;
      smartcase = true;
  
      # Undo and backup options
      # backup = false;
      # writebackup = false;
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
