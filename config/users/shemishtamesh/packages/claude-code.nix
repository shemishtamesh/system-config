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

          # Web access
          "WebFetch(*)"
          "WebSearch(*)"
        ];
      };
      theme = "auto";
    };
  };
}
