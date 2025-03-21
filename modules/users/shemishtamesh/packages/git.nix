{
  programs.git = {
    enable = true;
    userName = "shemishtamesh";
    userEmail = "shemishtamail@gmail.com";
    aliases = {
      plog = "log --all --decorate --oneline --graph"; # pretty log
      fpull = # sh
        ''
          !f() {
              git checkout --quiet HEAD &&
              case "$#" in
                  0) git fetch origin main:main ;;
                  1) git fetch origin "$1:$1" ;;
                  2) git fetch "$1" "$2:$2" ;;
                  3) git fetch "$1" "$2:$3" ;;
                  *) echo 'Too many arguments' >&2; exit 1 ;;
              esac &&
              git checkout --quiet -;
          }; f
        '';
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
