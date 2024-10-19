{ lib, ... }:
let
  keymap = (import ./nix_functions.nix).keymap;
in
{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };
    keymaps = [
      # system clipboard
      (keymap "v" "<leader>y" ''"+y:let @*=@+<CR>'' { silent = true; })
      (keymap [
        "n"
        "v"
      ] "<leader>Y" ''"+Y:let @*=@+<CR>'' { silent = true; })
      (keymap "n" "<leader>y" ''"+y'' { })
      (keymap [
        "n"
        "v"
      ] "<leader>p" ''"+p'' { })
      (keymap [
        "n"
        "v"
      ] "<leader>P" ''"+P'' { })

      # moving code segments
      (keymap "n" "<M-j>" "V:m '>+1<CR>gv=" { })
      (keymap "n" "<M-k>" "V:m '>-2<CR>gv=" { })
      (keymap "v" "<M-j>" "<cmd>m '>+1<CR>gv=gv" { })
      (keymap "v" "<M-k>" "<cmd>m '<-2<CR>gv=gv" { })

      # quickfix list navigation
      (keymap "n" "<M-o>" "<cmd>cprev<CR>" { })
      (keymap "n" "<M-i>" "<cmd>cnext<CR>" { })
      (keymap "n" "<leader>k" "<cmd>lprev<CR>" { })
      (keymap "n" "<leader>j" "<cmd>lnext<CR>" { })

      # replace current word
      (keymap "n" "<leader>rw" ":%s/<C-r><C-w>/t/gI<Left><Left><Left><BackSpace>" { })

      # make current file executable
      (keymap "n" "<leader>x" "<cmd>!chmod +x %<CR>" { silent = true; })
      (keymap "n" "<leader>X" "<cmd>!chmod -x %<CR>" { silent = true; })

      # toggle spell check
      (keymap "n" "<leader>sc" "<cmd>setlocal spell! spelllang=en_us<CR>" { })

      # toggle search highlighting highlighting
      (keymap "n" "<leader>n" "<cmd>set hlsearch!<CR>" { })

      # hex mode
      (keymap "n" "<leader>h" "<cmd>%!xxd<CR>" { })
      (keymap "n" "<leader>H" "<cmd>%!xxd -r<CR>" { })

      # faster exit
      (keymap "n" "Q" "<cmd>qa<CR>" { })
    ];
    userCommands = {
      W = {
        command = "wa";
      };
      Q = {
        command = "qa";
      };
      Qw = {
        command = "wqa";
      };
      QW = {
        command = "wqa";
      };
      Wq = {
        command = "wqa";
      };
      WQ = {
        command = "wqa";
      };
    };
    plugins.treesitter-textobjects.extraOptions.move =
      let
        textobjectStartDesc = isStart: if isStart then "start" else "end";
        textobjectNextDesc = isNext: if isNext then "next" else "previous";
        textobjectsMoveKey =
          isNext: isStart: key:
          "${if isNext then "]" else "["}${if isStart then key else lib.toUpper key}";
        textobjectsMoveAttributeSet = isNext: isStart: {
          "${textobjectsMoveKey isNext isStart "f"}" = {
            query = "@function.outer";
            desc = "Go to the ${textobjectStartDesc isStart} of the ${textobjectNextDesc isNext} function";
          };
          "${textobjectsMoveKey isNext isStart "c"}" = {
            query = "@class.outer";
            desc = "Go to the ${textobjectStartDesc isStart} of the ${textobjectNextDesc isNext} class";
          };
          "${textobjectsMoveKey isNext isStart "a"}" = {
            query = "@assignment.outer";
            query_group = "locals";
            desc = "Go to the ${textobjectStartDesc isStart} of the ${textobjectNextDesc isNext} assignment";
          };
          "${textobjectsMoveKey isNext isStart "l"}" = {
            query = "@loop.outer";
            query_group = "locals";
            desc = "Go to the ${textobjectStartDesc isStart} of the ${textobjectNextDesc isNext} loop";
          };
          "${textobjectsMoveKey isNext isStart "i"}" = {
            query = "@conditional.outer";
            query_group = "locals";
            desc = "Go to the ${textobjectStartDesc isStart} of the ${textobjectNextDesc isNext} conditional";
          };
          "${textobjectsMoveKey isNext isStart "k"}" = {
            query = "@block.outer";
            query_group = "locals";
            desc = "Go to the ${textobjectStartDesc isStart} of the ${textobjectNextDesc isNext} block";
          };
        };
      in
      {
        goto_next_start = textobjectsMoveAttributeSet true true;
        goto_previous_start = textobjectsMoveAttributeSet false true;
        goto_next_end = textobjectsMoveAttributeSet true false;
        goto_previous_end = textobjectsMoveAttributeSet false false;
      };
    plugins.treesitter-textobjects.extraOptions.select.keymaps = {
      "if" = {
        query = "@function.inner";
        desc = "Select inner part of a function region";
      };
      "af" = {
        query = "@function.outer";
        desc = "Select outer part of a function region";
      };
      "ic" = {
        query = "@class.inner";
        desc = "Select inner part of a class region";
      };
      "ac" = {
        query = "@class.outer";
        desc = "Select outer part of a class region";
      };
      "ia" = {
        query = "@assignment.inner";
        query_group = "locals";
        desc = "Select inner part of a assignment region";
      };
      "aa" = {
        query = "@assignment.outer";
        query_group = "locals";
        desc = "Select outer part of an assignment region";
      };
      "il" = {
        query = "@loop.inner";
        query_group = "locals";
        desc = "Select inner part of a loop region";
      };
      "al" = {
        query = "@loop.outer";
        query_group = "locals";
        desc = "Select outer part of a loop region";
      };
      "ii" = {
        query = "@conditional.inner";
        query_group = "locals";
        desc = "Select inner part of a conditional region";
      };
      "ai" = {
        query = "@conditional.outer";
        query_group = "locals";
        desc = "Select outer part of a conditional region";
      };
      "ik" = {
        query = "@block.inner";
        query_group = "locals";
        desc = "Select inner part of a block region";
      };
      "ak" = {
        query = "@block.outer";
        query_group = "locals";
        desc = "Select outer part of a block region";
      };
      "as" = {
        query = "@scope";
        query_group = "locals";
        desc = "Select language scope";
      };
    };
  };
}
