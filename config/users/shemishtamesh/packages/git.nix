{ pkgs, ... }:
let
  clone_bare = pkgs.writeShellScriptBin "clone_bare" ''
    #!/usr/bin/env bash
    set -euo pipefail

    url=''${1:? "usage: clb <repo-url> [target-dir]"}

    # Derive dir name unless provided; works for https/ssh/scp-like URLs
    dir=''${2:-$(printf '%s' "$url" | sed -E 's#/$##; s#^.*[:/]+##; s#\.git$##')}

    mkdir -p "$dir"
    cd "$dir"

    # Bare clone into .git
    git clone --bare "$url" .git

    # 1) Prefer HEAD from the newly-cloned bare repo
    branch="$(git --git-dir=.git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
    if [ -z "''${branch:-}" ]; then
      # 2) Fallback: ask the remote where HEAD points
      branch="$(git ls-remote --symref "$url" HEAD 2>/dev/null \
                | awk '/^ref:/ {print $3}' | sed 's#^refs/heads/##' || true)"
    fi
    # 3) Fallbacks: main → master → first head found
    if [ -z "''${branch:-}" ] && git --git-dir=.git show-ref --verify --quiet "refs/heads/main"; then
      branch=main
    fi
    if [ -z "''${branch:-}" ] && git --git-dir=.git show-ref --verify --quiet "refs/heads/master"; then
      branch=master
    fi
    if [ -z "''${branch:-}" ]; then
      branch="$(git --git-dir=.git show-ref | awk '/refs\/heads\// {sub(/^.*refs\/heads\//,"",$2); print $2; exit}')"
    fi

    if [ -z "''${branch:-}" ]; then
      echo "Could not detect a default branch (tried .git/HEAD, origin/HEAD, main, master)." >&2
      exit 1
    fi

    # In a bare clone, branches are in refs/heads/*, not refs/remotes/*
    git --git-dir=.git worktree add -B "$branch" "$branch" "$branch"

    echo "✓ Created bare repo in $(pwd)/.git and worktree in $(pwd)/$branch (branch: $branch)"
  '';
in
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
      clb = "!${clone_bare}";
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
