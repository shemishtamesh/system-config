{
  programs.nixvim.plugins.comment = {
    enable = true;
    settings = {
      toggler = {
        line = "<C-/>";
        block = "<C-;>";
      };
      opleader = {
        line = "<leader>/";
        block = "<leader><C-/>";
      };
    };
  };
}
