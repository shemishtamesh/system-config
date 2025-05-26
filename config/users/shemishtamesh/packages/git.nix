{ pkgs, ... }:
{
  home.packages = with pkgs; [ gitleaks ];
  programs.git = {
    enable = true;
    userName = "shemishtamesh";
    userEmail = "shemishtamail@gmail.com";
    aliases = {
      a = "add";
      b = "branch";
      c = "commit";
      ch = "checkout";
      cl = "clone";
      d = "diff";
      dt = "difftool";
      f = "fetch";
      i = "init";
      l = "log --all --decorate --oneline --graph --pretty=format:'%C(yellow)%h %C(green)%an %C(blue)%ar %C(magenta)%D %C(white)%s'";
      m = "merge";
      mt = "mergetool";
      p = "pull";
      ps = "push";
      r = "reset";
      rb = "rebase";
      rm = "remote";
      rt = "remote";
      s = "status";
      sh = "stash";
      sw = "switch";
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
      };
    };
    ignores = [
      ".venv"
      ".envrc"
    ];
    hooks.pre-commit =
      pkgs.writeScript "pre-commit-script" # sh
        ''
          ${pkgs.gitleaks}/bin/gitleaks git \
              --no-banner \
              --staged \
              --verbose \
              --redact \
              --log-level warn
        '';
    extraConfig = {
      merge = {
        tool = "nvimdiff";
        conflictstyle = "diff3";
      };
      mergetool.keepBackup = false;
      diff = {
        tool = "nvimdiff";
        colorMoved = "default";
      };
      difftool.prompt = false;
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        compression = 9;
        whitespace = "error";
        preloadindex = true;
      };
      pull.ff = "only";
      "url \"git@github.com:/\"".insteadOf = "gh:";
      "url \"git@github.com:shemishtamesh/\"".insteadOf = "me:";
      status = {
        short = true;
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };
      commit.verbose = true;
      branch.sort = "-committerdate";
      tag.sort = "-taggerdate";
    };
  };
}
