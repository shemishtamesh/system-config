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
          };
          lua_ls = {
            enable = true;
            settings = {
              telemetry.enable = false;
              diagnostics.globals = [ "vim" ];
            };
          };
        };
        # keymaps = {
        #   lspBuf = {
        #     "<leader>la" = "code_action";
        #     "<leader>lf" = "format";
        #     "<leader>ln" = "rename";
        #     "<leader>lm" = "implementation";
        #     "<leader>li" = "incoming_calls";
        #     "<leader>lo" = "outgoing_calls";
        #     "<leader>lr" = "references";
        #     "<leader>lh" = "signature_help";
        #     "<leader>lt" = "type_definition";
        #     "<leader>lc" = "typehierarchy";
        #     "<leader>ls" = "workspace_symbol";
        #     "gd" = "definition";
        #     "gD" = "declaration";
        #   };
        #   diagnostic = {
        #     "<leader>ld" = "setqflist";
        #     "]d" = "goto_next";
        #     "[d" = "goto_prev";
        #   };
        # };
      };
    };
    keymaps = [
      (keymap "n" "<leader>la" "<cmd>vim.lsp.buf.code_action()<CR>" { silent = true; })
      (keymap "n" "<leader>lf" "<cmd>vim.lsp.buf.format()<CR>" { silent = true; })
      (keymap "n" "<leader>ln" "<cmd>vim.lsp.buf.rename()<CR>" { silent = true; })
      (keymap "n" "<leader>lm" "<cmd>vim.lsp.buf.implementation()<CR>" { silent = true; })
      (keymap "n" "<leader>li" "<cmd>vim.lsp.buf.incoming_calls()<CR>" { silent = true; })
      (keymap "n" "<leader>lo" "<cmd>vim.lsp.buf.outgoing_calls()<CR>" { silent = true; })
      (keymap "n" "<leader>lr" "<cmd>vim.lsp.buf.references()<CR>" { silent = true; })
      (keymap "n" "<leader>lh" "<cmd>vim.lsp.buf.signature_help()<CR>" { silent = true; })
      (keymap "n" "<leader>lt" "<cmd>vim.lsp.buf.type_definition()<CR>" { silent = true; })
      (keymap "n" "<leader>lc" "<cmd>vim.lsp.buf.typehierarchy()<CR>" { silent = true; })
      (keymap "n" "<leader>ls" "<cmd>vim.lsp.buf.workspace_symbol()<CR>" { silent = true; })
      (keymap "n" "gd" "<cmd>vim.lsp.buf.definition()<CR>" { silent = true; })
      (keymap "n" "gD" "<cmd>vim.lsp.buf.declaration()<CR>" { silent = true; })
      (keymap "n" "<leader>ld" "<cmd>vim.diagnostic.setqflist()<CR>" { silent = true; })
      (keymap "n" "]d" "<cmd>vim.lsp.buf.goto_next()<CR>" { silent = true; })
      (keymap "n" "[d" "<cmd>vim.lsp.buf.goto_prev()<CR>" { silent = true; })
    ];
  };
}
