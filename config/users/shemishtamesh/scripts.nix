{
  pkgs,
  host,
  shared,
  ...
}:
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
    (pkgs.writeShellScriptBin "timestamp" ''
      if [[ $# -eq 0 ]]; then
        echo "Adds the current date to a file's name"
        echo 'timestamp <arg1>'
        exit 1
      fi
      date_str=$(date +%Y%m%d)
      original_file="$1"
      dir=$(dirname "$original_file")
      basename=$(basename "$original_file")

      name="${basename%.*}"
      extension="${basename##*.}"

      # Create the new filename with date
      if [[ "$extension" == "$basename" ]]; then
        # No extension
        new_filename="${name}-${date_str}"
      else
        # Has extension
        new_filename="${name}-${date_str}.${extension}"
      fi

      # Rename the file
      mv "$original_file" "$dir/$new_filename"
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
      exec $command --impure
    '')
    (pkgs.writeShellScriptBin "reload_configs" "${shared.scripts.reload_configs}")
    (pkgs.writeShellScriptBin "list_specialisations" ''
      nix eval --json $FLAKE#homeConfigurations.$USER@$(hostname) \
        --apply 'cfg: builtins.attrNames cfg.config.specialisation'
    '')
    (pkgs.writeShellScriptBin "switch_specialisation" ''
      if [ $# -eq 0 ]; then
        home-manager switch --flake ${shared.constants.FLAKE_ROOT}
      else
        home-manager switch --flake ${shared.constants.FLAKE_ROOT} --specialisation $1
      fi
      ${shared.scripts.reload_configs}
    '')
  ]
  ++ (
    if pkgs.lib.last (pkgs.lib.splitString "-" host.system) == "darwin" then
      [
        (pkgs.writeShellScriptBin "toggle_sleep" ''
          if [[ $# -gt 0 ]]; then
            echo 'Toggles enablement of sleep'
            exit 1
          fi
          current_status=$(echo "1 - $(pmset -g | grep SleepDisabled | awk '{ print $2 }')" | bc)
          sudo pmset -a disablesleep $current_status
          case $current_status in
            0) echo 'Sleep enabled';;
            1) echo 'Sleep disabled';;
          esac
        '')
      ]
    else
      [ ]
  );
}
