let
  mapping = {
    "<C-Space>" = "cmp.mapping.complete()";
    "<C-y>" = "cmp.mapping.confirm({ select = true })";
    "<C-n>" = "cmp.mapping.select_next_item()";
    "<C-p>" = "cmp.mapping.select_prev_item()";
    "<C-f>" = "cmp.mapping.scroll_docs(4)";
    "<C-b>" = "cmp.mapping.scroll_docs(-4)";
  };
  search_options = {
    inherit mapping;
    sources = [
      { name = "buffer"; }
    ];
  };
  command_options = {
    inherit mapping;
    sources = [
      { name = "async_path"; }
      { name = "cmdline"; }
    ];
  };
in
{
  programs.nixvim = {
    opts.completeopt = [
      "menu"
      "menuone"
      "noselect"
    ];
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      cmdline = {
        "/" = search_options;
        "?" = search_options;
        ":" = command_options;
      };
      settings = {
        inherit mapping;
        sources = [
          { name = "nvim_lsp"; }
          { name = "async_path"; }
          { name = "buffer"; }
          { name = "codeium"; }
          { name = "calc"; }
        ];
      };
    };
  };
}
