{
  programs.nixvim.plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      mappings = {
        "<C-Space>" = "cmp.mapping.complete()";
      };
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "codeium"; }
      ];
    };
  };
}
