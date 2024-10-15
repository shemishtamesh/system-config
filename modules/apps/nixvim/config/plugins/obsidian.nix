{
  programs.nixvim.plugins.obsidian = {
    enable = true;
    settings = {
      disable_frontmatter = true;
      workspaces = [
        { name = "general_vault"; path = "~/Documents/general_vault"; }
      ];
      daily_notes = {
        folder = "journal";
        date_format = "%Y-%m-%d";
        alias_format = "%B %-d, %Y";
        default_tags = [ "daily" ];
        template = "daily.md";
      };
      templates = {
          folder = "templates";
          date_format = "%Y-%m-%d";
          time_format = "%H:%M";
      };
    };
  };
}
