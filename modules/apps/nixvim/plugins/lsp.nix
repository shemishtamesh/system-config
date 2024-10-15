let
  keymap = (import ../nix_functions.nix).keymap;
in
{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        nil-ls.enable = true;
        pylsp.enable = true;
        rust-analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
        lua-ls = {
          enable = true;
          settings.telemetry.enable = false;
        };
      };
    };
    keymaps = [
      (keymap "n" "<leader>lf" "<cmd>lua vim.lsp.buf.format()<CR>" { })
      (keymap "n" "<leader>lh" "<cmd>lua vim.lsp.buf.hover()<CR>" { })
      (keymap "n" "<leader>ln" "<cmd>lua vim.lsp.buf.rename()<CR>" { })
    ];
  };
}
