let
  keymap = (import ../nix_functions.nix).keymap;
in
{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      luaConfig.post = # lua
        ''
          vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
              if vim.fn.argv(0) == "" then
                require("telescope.builtin").find_files()
              end
            end,
          })
        '';
    };
    keymaps = [
      (keymap "n" "<leader>fo" "<cmd>Telescope oldfiles<CR>" { })
      (keymap "n" "<leader>ff" "<cmd>Telescope find_files<CR>" { })
      (keymap "n" "<leader>fl" "<cmd>Telescope live_grep<CR>" { })
      (keymap "n" "<leader>fg" "<cmd>Telescope git_files<CR>" { })
      (keymap "n" "<leader>fs" "<cmd>Telescope grep_string<CR>" { })
      (keymap "n" "<leader>fc" "<cmd>Telescope command_history<CR>" { })
      (keymap "n" "<leader>fq" "<cmd>Telescope quickfix<CR>" { })
      (keymap "n" "<leader>fj" "<cmd>Telescope jumplist<CR>" { })
      (keymap "n" "<leader>fk" "<cmd>Telescope keymaps<CR>" { })
    ];
  };
}
