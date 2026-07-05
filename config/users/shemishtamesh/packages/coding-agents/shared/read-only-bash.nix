let
  allowCmds = [
    "grep *"
    "rg *"

    "find *"

    "ls"
    "ls *"

    "exa"
    "exa *"

    "eza"
    "eza *"

    "cat *"
    "head *"
    "tail *"
    "sort *"
    "uniq *"
    "wc *"
    "file *"
    "stat *"
    "realpath *"
    "readlink *"
    "strings *"
    "od *"
    "xxd *"
    "hexdump *"
    "cut *"
    "tr *"
    "column *"
    "fmt *"
    "diff *"
    "comm *"
    "jq *"
    "yq *"
    "dirname *"
    "basename *"
    "expand *"
    "unexpand *"
    "nl *"
    "fold *"
    "pr *"
    "ptx *"

    "tree"
    "tree *"

    "pwd"
    "pwd *"

    "which *"

    "env"
    "env *"

    "echo *"
    "printf *"

    "timeout *"

    "true"
    "false"

    "uname *"
    "hostname"
    "hostname -I*"
    "uptime"
    "whoami"
    "id *"
    "date"
    "date +*"
    "nproc"
    "lscpu *"
    "lsblk *"
    "df *"
    "du *"
    "free *"
    "ps *"

    "git status*"
    "git diff*"
    "git log*"
    "git show*"
    "git blame*"
    "git branch*"
    "git rev-parse*"

    "nix log*"
    "nix eval*"
    "nix search*"
    "nix why-depends*"
    "nix flake show*"
    "nix flake metadata*"
    "nix flake check*"
    "nix store diff-closures*"
    "nix profile list*"
    "nix profile history*"
    "nix show*"
    "nix describe*"
    "nix store ls *"
    "nix store cat *"
    "nix store path-from-hash-part *"
    "nix store info"
    "nix hash *"
    "nix path-info *"
    "nix registry list"
    "nix registry resolve *"
    "nix derivation show *"
    "nix nar ls *"
    "nix nar cat *"
    "nix realisation info *"
    "nix-locate *"

    "curl *"
  ];

  askCmds = [
    "find * -exec*"
    "find * -execdir*"
  ];

  allowMap = builtins.listToAttrs (
    map (c: {
      name = c;
      value = "allow";
    }) allowCmds
  );
  askMap = builtins.listToAttrs (
    map (c: {
      name = c;
      value = "ask";
    }) askCmds
  );

  askBash = {
    "*" = "ask";
  }
  // allowMap;

  denyBash = {
    "*" = "deny";
  }
  // allowMap;

  toClaudeBash = cmd: "Bash(${cmd})";
  claudeAllow = map toClaudeBash allowCmds;
  claudeAsk = map toClaudeBash askCmds;
in
{
  inherit
    allowCmds
    askCmds
    allowMap
    askMap
    askBash
    denyBash
    toClaudeBash
    claudeAllow
    claudeAsk
    ;
}
