{
  programs.claude-code = {
    enable = true;
    settings = {
      includeCoAuthoredBy = false;
      permissions = {
        disableBypassPermissionsMode = "disable";
      };
      theme = "auto";
    };
  };
}
