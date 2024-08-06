{ ... }:
let
shellAliases = {
    n = "nvim";
};
in {
    programs.zsh = {
        enable = true;
        shellAliases = shellAliases;
    };
}
