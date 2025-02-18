{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      folding = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        auto_install = true;
      };
    };
    treesitter-context = {
      enable = true;
      settings.max_lines = 1;
    };
    treesitter-textobjects = {
      enable = true;
      extraOptions = {
        lookahead = true;
        move = {
          enable = true;
          set_jumps = true;
        };
        select = {
          enable = true;
          lookahead = true;
        };
      };
    };
  };
}
