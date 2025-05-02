{
  programs.git = {
    enable = true;
    userName = "shemishtamesh";
    userEmail = "shemishtamail@gmail.com";
    aliases = {
      l = "log --all --decorate --oneline --graph --pretty=format:'%C(yellow)%h %C(green)%an %C(blue)%ar %C(magenta)%D %C(white)%s'";
      b = "branch";
      s = "status";
      sw = "switch";
      c = "checkout";
      a = "add";
      r = "reset";
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
