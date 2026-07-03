{
  programs.claude-code = {
    enable = true;
    settings = {
      includeCoAuthoredBy = false;
      permissions = {
        disableBypassPermissionsMode = "disable";
        allow = [
          # claude-code auto-allows many read-only commands already:
          # ls, cat, echo, pwd, head, tail, grep, find, wc, which, diff, stat, du, cd,
          # and read-only git forms — no need to list those explicitly.
          # Also, Bash(cmd *) covers bare `cmd` too (trailing space+* matches end-of-string).

          # Read-only bash commands not in claude-code's built-in auto-allow list
          "Bash(rg *)"
          "Bash(exa *)"
          "Bash(eza *)"
          "Bash(sort *)"
          "Bash(uniq *)"
          "Bash(file *)"
          "Bash(strings *)"
          "Bash(tree *)"
          "Bash(env *)"
          "Bash(printf *)"
          "Bash(timeout *)"
          "Bash(true *)"
          "Bash(false *)"

          # Read-only nix
          "Bash(nix log *)"
          "Bash(nix eval *)"
          "Bash(nix search *)"
          "Bash(nix why-depends *)"
          "Bash(nix flake show *)"
          "Bash(nix flake metadata *)"
          "Bash(nix flake check *)"
          "Bash(nix store diff-closures *)"
          "Bash(nix profile list *)"
          "Bash(nix profile history *)"
          "Bash(nix show *)"
          "Bash(nix describe *)"

          # Web access
          "WebFetch(*)"
          "WebSearch(*)"
        ];
      };
      theme = "auto";
    };
  };
}
