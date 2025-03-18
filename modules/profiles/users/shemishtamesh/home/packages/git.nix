{
  programs.git = {
    enable = true;
    userName = "shemishtamesh";
    userEmail = "shemishtamail@gmail.com";
    aliases = {
      plog = "log --all --decorate --oneline --graph";
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
      };
    };
  };
}
