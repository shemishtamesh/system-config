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
          nixd.enable = true;
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
              workspace = {
                library = [
                  # lua
                  "vim.env.VIMRUNTIME"
                ];
              };
            };
          };
        };
        keymaps = {
          lspBuf = {
            "<leader>la" = "code_action";
            "<leader>lf" = "format";
            "<leader>ln" = "rename";
            "<leader>lm" = "implementation";
            "<leader>li" = "incoming_calls";
            "<leader>lo" = "outgoing_calls";
            "<leader>lr" = "references";
            "<leader>lh" = "signature_help";
            "<leader>lt" = "type_definition";
            "<leader>lc" = "typehierarchy";
            "<leader>ls" = "workspace_symbol";
            "gd" = "definition";
            "gD" = "declaration";
          };
          diagnostic = {
            "<leader>ld" = "setqflist";
            "]d" = "goto_next";
            "[d" = "goto_prev";
          };
        };
      };
    };
  };
}
