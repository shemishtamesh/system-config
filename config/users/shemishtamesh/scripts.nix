{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "bak" ''
      if [[ $# -eq 0 ]]; then
        echo 'Adds or removes `.bak` from the names of files and directories'
        echo 'bak <arg1>'
        exit 1
      fi
      filename="$1"
      if [[ "$filename" =~ .bak$ ]]; then
          mv -i "$filename" "''${filename%.bak}";
          exit 0;
      else
          mv -i "$filename" "$filename.bak";
          exit 0;
      fi
      echo "Error: $filename is not a valid file or directory.";
      exit 1;
    '')
    (pkgs.writeShellScriptBin "s" ''
      if [[ $# -eq 0 ]]; then
        echo 'Enters an impure nix shell with the specified packages.'
        echo 'Usage: s <arg1> <arg2> ...'
        exit 1
      fi
      command="nix --extra-experimental-features nix-command --extra-experimental-features flakes shell"
      for arg in "$@"; do
        command="$command nixpkgs#$arg"
      done
      export NIXPKGS_ALLOW_UNFREE=1
      eval "$command --impure"
    '')
  ];
}
