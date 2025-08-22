{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gitleaks
    koji
  ];
  programs.git = {
    enable = true;
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
      ca = "commit --all";
      cp = "!f() { if [ -n \"$1\" ]; then git commit --message \"$1\"; else git commit; fi; git push; }; f";
      cap = "!f() { if [ -n \"$1\" ]; then git commit --all --message \"$1\"; else git commit --all; fi; git push; }; f";
      ch = "checkout";
      cl = "clone";
      clb = ''
        !f() { \
          set -e; \
          url="$1"; \
          dir="''${2:-$(basename "$url" .git)}"; \
          mkdir -p "$dir"; cd "$dir"; \
          git clone --bare "$url" .git; \
          branch=$(git --git-dir=.git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@' || true); \
          if [ -z "$branch" ] && git --git-dir=.git rev-parse --verify -q refs/remotes/origin/main >/dev/null; then branch=main; fi; \
          if [ -z "$branch" ] && git --git-dir=.git rev-parse --verify -q refs/remotes/origin/master >/dev/null; then branch=master; fi; \
          if [ -z "$branch" ]; then branch=$(git --git-dir=.git for-each-ref --format='%(refname:short)' 'refs/remotes/origin/*' | head -n1); fi; \
          if [ -z "$branch" ]; then echo >&2 "Could not detect a default branch (tried origin/HEAD, main, master)."; exit 1; fi; \
          git --git-dir=.git worktree add -B "$branch" "$branch" "origin/$branch"; \
        }; f
      '';
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
      remote.pushDefault = "origin";
    };
  };
}
