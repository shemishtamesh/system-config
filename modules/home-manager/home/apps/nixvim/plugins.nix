{
  imports = [
    ./plugins/lsp.nix
    ./plugins/completions.nix
    ./plugins/telescope.nix
    ./plugins/undotree.nix
    ./plugins/treesitter.nix
    ./plugins/comment.nix
    ./plugins/codeium.nix
    ./plugins/zen-mode.nix
    ./plugins/indent-blankline.nix
    ./plugins/which-key.nix
    ./plugins/snacks.nix
    ./plugins/dadbod.nix
    # ./plugins/obsidian.nix
    # ./plugins/alpha.nix
  ];
  programs.nixvim.plugins = {
    lualine.enable = true;
    nvim-colorizer.enable = true;
    tmux-navigator.enable = true;
    otter.enable = true;
    numbertoggle.enable = true;
    gitsigns.enable = true;
    web-devicons.enable = true;
    snacks.enable = true;
    # rustaceanvim.enable = true;
    # "dressing.nvim".enable = true;
    # vimtex.enable = true;
    # vim-surround.enable = true;
    # gen.enable = true
    # vim-asciidoctor.enable = true;
    # beacon.enable = true;
    # vim-dadbod.enable = true;
    # vim-dadbod-ui.enable = true;
    # vim-dadbod-completion.enable = true;
    # noice.enable =  true;
  };
}
