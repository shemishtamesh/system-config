{
  imports = [
    ./plugins/lsp.nix
    ./plugins/completions.nix
    ./plugins/telescope.nix
    ./plugins/undotree.nix
    ./plugins/treesitter.nix
    ./plugins/obsidian.nix
  ];
  programs.nixvim.plugins = {
    lualine.enable = true;
    zen-mode.enable = true;
    comment.enable = true;
    indent-blankline.enable = true;
    nvim-colorizer.enable = true;
    tmux-navigator.enable = true;
    which-key.enable = true;
    # numbertoggle.enable = true;
    # rustaceanvim.enable = true;
    # nvim-web-devicons.enable = true;
    # "dressing.nvim".enable = true;
    # vimtex.enable = true;
    # vim-surround.enable = true;
    # codeium.enable = true;
    # gen.enable = true
    # vim-asciidoctor.enable = true;
    # beacon.enable = true;
    # vim-dadbod.enable = true;
    # vim-dadbod-ui.enable = true;
    # vim-dadbod-completion.enable = true;
    # noice.enable =  true;
  };
}
