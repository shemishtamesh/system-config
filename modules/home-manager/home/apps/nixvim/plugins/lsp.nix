{ pkgs, ... }:
let
  keymap = (import ../nix_functions.nix).keymap;
in
{
  programs.nixvim = {
    diagnostics.signs.text.__raw = # lua
      ''
        {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.WARN] = "",
        }
      '';
    plugins = {
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd = {
            enable = true;
            settings.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
          };
          pyright.enable = true;
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
            settings.diagnostic.refreshSupport = false;
          };
          lua_ls = {
            enable = true;
            settings = {
              telemetry.enable = false;
              diagnostics.globals = [
                "vim"
                "love"
              ];
              workspace = {
                library = [
                  "${pkgs.neovim}/share/nvim/runtime"
                  "\${3rd}/love2d/library"
                ];
                checkThirdParty = false;
              };
            };
          };
        };
      };
    };
    keymaps = [
      (keymap "n" "<leader>la" "<cmd>lua vim.lsp.buf.code_action()<CR>" { silent = true; })
      (keymap "n" "<leader>lf" "<cmd>lua vim.lsp.buf.format()<CR>" { silent = true; })
      (keymap "n" "<leader>ln" "<cmd>lua vim.lsp.buf.rename()<CR>" { silent = true; })
      (keymap "n" "<leader>lm" "<cmd>lua vim.lsp.buf.implementation()<CR>" { silent = true; })
      (keymap "n" "<leader>li" "<cmd>lua vim.lsp.buf.incoming_calls()<CR>" { silent = true; })
      (keymap "n" "<leader>lo" "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>" { silent = true; })
      (keymap "n" "<leader>lr" "<cmd>lua vim.lsp.buf.references()<CR>" { silent = true; })
      (keymap "n" "<leader>lh" "<cmd>lua vim.lsp.buf.signature_help()<CR>" { silent = true; })
      (keymap "n" "<leader>lt" "<cmd>lua vim.lsp.buf.type_definition()<CR>" { silent = true; })
      (keymap "n" "<leader>lc" "<cmd>lua vim.lsp.buf.typehierarchy()<CR>" { silent = true; })
      (keymap "n" "<leader>ls" "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>" { silent = true; })
      (keymap "n" "gd" "<cmd>lua vim.lsp.buf.definition()<CR>" { silent = true; })
      (keymap "n" "gD" "<cmd>lua vim.lsp.buf.declaration()<CR>" { silent = true; })
      (keymap "n" "<leader>ld" "<cmd>lua vim.diagnostic.setqflist()<CR>" { silent = true; })
      (keymap "n" "]d" "<cmd>lua vim.lsp.buf.goto_next()<CR>" { silent = true; })
      (keymap "n" "[d" "<cmd>lua vim.lsp.buf.goto_prev()<CR>" { silent = true; })
    ];
  };
}
