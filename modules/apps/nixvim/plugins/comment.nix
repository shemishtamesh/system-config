{
  programs.nixvim.plugins.comment = {
    enable = true;
    settings = {
      toggler = {
        line = "<leader>//";
        block = "<leader>;;";
      };
      opleader = {
        line = "<leader>/";
        block = "<leader>;";
      };
    };
  };
}
