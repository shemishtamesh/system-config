let
  shared = import ../shared { };
in
{
  programs.claude-code = {
    enable = true;
    settings = {
      includeCoAuthoredBy = false;
      permissions = {
        disableBypassPermissionsMode = "disable";
        allow = shared.claudeAllow ++ [
          "WebFetch(*)"
          "WebSearch(*)"
        ];
      };
      theme = "auto";
    };
  };
}
