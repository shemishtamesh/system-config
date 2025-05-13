{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "bak" ''
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
        echo 'Enters a nix shell with the specified packages, and starting $SHELL. with Usage: s <arg1> <arg2> ...'
        exit 1
      fi
      command="nix --extra-experimental-features nix-command --extra-experimental-features flakes shell"
      for arg in "$@"; do
        command="$command nixpkgs#$arg"
      done
      eval "$command --command $SHELL"
    '')
  ];
}
