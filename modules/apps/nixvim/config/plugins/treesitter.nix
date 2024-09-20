{ lib, ... }:
{
  plugins = {
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
    treesitter = {
      enable = true;
      folding = true;
      settings = {
        auto_install = true;
        indent = {
          enable = true;
        };
      };
    };
  };
}
