let
  search_options = {
    mapping.__raw = ''
      cmp.mapping.preset.cmdline({ ["<C-y>"] = { c = cmp.mapping.confirm() } })
    '';
    sources = [
      { name = "buffer"; }
    ];
  };
  command_options = {
    mapping.__raw = ''
      cmp.mapping.preset.cmdline({ ["<C-y>"] = { c = cmp.mapping.confirm() } })
    '';
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
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        };
        sources = [
          { name = "calc"; }
          { name = "codeium"; }
          { name = "nvim_lsp"; }
          { name = "buffer"; }
          {
            name = "buffer";
            # Words from other open buffers can also be suggested.
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
          { name = "async_path"; }
          { name = "vim-dadbod-completion"; }
        ];
        experimental.ghost_text = true;
      };
    };
  };
}
