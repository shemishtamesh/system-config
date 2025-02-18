{ pkgs, ... }:

{
  imports = [
    ./plugins/lsp.nix
    ./plugins/completions.nix
    ./plugins/telescope.nix
    ./plugins/undotree.nix
    ./plugins/treesitter.nix
    ./plugins/comment.nix
    # ./plugins/codeium.nix
    ./plugins/zen-mode.nix
    ./plugins/indent-blankline.nix
    ./plugins/which-key.nix
    ./plugins/snacks.nix
    ./plugins/dadbod.nix
    ./plugins/flash.nix
    ./plugins/nvim-surround.nix
    # ./plugins/dashboard.nix
    # ./plugins/obsidian.nix
  ];
  programs.nixvim = {
    plugins = {
      lualine.enable = true;
      colorizer.enable = true;
      tmux-navigator.enable = true;
      otter.enable = true;
      numbertoggle.enable = true;
      gitsigns.enable = true;
      web-devicons.enable = true;
      # rustaceanvim.enable = true;
      # "dressing.nvim".enable = true;
      # vimtex.enable = true;
      # vim-surround.enable = true;
      # gen.enable = true
      # vim-asciidoctor.enable = true;
      # beacon.enable = true;
      # noice.enable =  true;
    };
    extraPlugins = with pkgs; [
      (vimUtils.buildVimPlugin {
        pname = "cheat.sh-vim";
        version = "latest";
        src = fetchFromGitHub {
          owner = "dbeniamine";
          repo = "cheat.sh-vim";
          rev = "master";
          sha256 = "sha256-awowfQ4q9CCX2V7Vhf1EjKr2GaqQFPOpdwq7FT8os0Y=";
        };
      })
    ];
  };
}
