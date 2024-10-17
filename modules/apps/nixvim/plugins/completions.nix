{
  programs.nixvim.plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      enable_chat = true;
      mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-y>" = "cmp.mapping.confirm({ select = true })";
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
      };
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "cmdline"; }
        { name = "codeium"; }
      ];
    };
  };
}
