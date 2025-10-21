{ pkgs, shared, ... }:
{
  home.packages = with pkgs; [
    gitleaks
    koji
  ];
  programs.git = {
    enable = true;
    settings = {
      userName = "shemishtamesh";
      userEmail = "shemishtamail@gmail.com";
      aliases = {
        a = "add";
        b = "branch";
        w = "worktree";
        wa = "worktree add";
        wr = "worktree remove";
        wl = "worktree list";
        c = "commit";
        cm = "commit --message";
        ca = "commit --all";
        cam = "commit --all --message";
        cp = "!f() { if [ -n \"$1\" ]; then git commit --message \"$1\"; else git commit; fi; git push; }; f";
        cap = "!f() { if [ -n \"$1\" ]; then git commit --all --message \"$1\"; else git commit --all; fi; git push; }; f";
        ch = "checkout";
        cl = "clone";
        clb = "!${shared.scripts.git_clone_bare}";
        d = "diff";
        ds = "diff --compact-summary";
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
        remote.pushDefault = "origin";
        push.autoSetupRemote = "true";
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
  };
}
