{
  pkgs,
  stable-pkgs,
  config,
  ...
}:
let
  payload = stable-pkgs.callPackage ./package.nix { };
  fonts = pkgs.makeFontsConf { fontDirectories = [ pkgs.dejavu_fonts ]; };
  # print urls so oauth can be completed without weakening sandbox
  browserBridge = pkgs.writeShellScriptBin "xdg-open" ''
    # electron discards child stderr
    printf 'Open this URL in your browser:\n%s\n' "$@" > /proc/1/fd/2
  '';
  runtime = pkgs.closureInfo {
    rootPaths = [
      payload
      pkgs.bash
      pkgs.coreutils
      browserBridge
      pkgs.cacert
      pkgs.dejavu_fonts
      fonts
    ];
  };
  launcher = pkgs.writeShellApplication {
    name = "learnharness";
    runtimeInputs = [
      pkgs.bubblewrap
      pkgs.coreutils
    ];
    text = ''
      if (( $# )); then
        echo "learnharness does not accept arguments" >&2
        exit 1
      fi
      : "''${XDG_RUNTIME_DIR:?A Wayland session is required}"
      : "''${WAYLAND_DISPLAY:?A Wayland session is required}"
      if [[ "$WAYLAND_DISPLAY" == */* ]]; then
        echo "Expected a Wayland socket name, not a path" >&2
        exit 1
      fi
      state=${pkgs.lib.escapeShellArg "${config.xdg.dataHome}/learnharness-sandbox"}
      imports=${pkgs.lib.escapeShellArg "${config.home.homeDirectory}/Documents/LearnHarness"}
      umask 077
      mkdir -p "$state" "$imports"
      mounts=()
      while IFS= read -r path; do
        mounts+=(--ro-bind "$path" "$path")
      done < ${runtime}/store-paths
      exec bwrap \
        --unshare-user --unshare-pid --unshare-ipc --unshare-uts --unshare-cgroup \
        --die-with-parent --new-session --cap-drop ALL \
        --clearenv \
        --proc /proc --dev /dev --tmpfs /tmp --tmpfs /run \
        --dir /etc --dir /home --dir /nix/store \
        "''${mounts[@]}" \
        --ro-bind /etc/resolv.conf /etc/resolv.conf \
        --ro-bind /etc/hosts /etc/hosts \
        --bind "$state" /home/learner \
        --ro-bind "$imports" /home/learner/Imports \
        --dir /run/learnharness --chmod 0700 /run/learnharness \
        --ro-bind "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" /run/learnharness/wayland-0 \
        --symlink ${pkgs.bash}/bin/sh /bin/sh \
        --setenv HOME /home/learner \
        --setenv USER learner \
        --setenv XDG_CONFIG_HOME /home/learner/.config \
        --setenv XDG_DATA_HOME /home/learner/.local/share \
        --setenv XDG_CACHE_HOME /home/learner/.cache \
        --setenv XDG_RUNTIME_DIR /run/learnharness \
        --setenv WAYLAND_DISPLAY wayland-0 \
        --setenv XDG_SESSION_TYPE wayland \
        --setenv PATH ${browserBridge}/bin:${pkgs.coreutils}/bin:${pkgs.bash}/bin \
        --setenv TMPDIR /tmp \
        --setenv LANG C.UTF-8 \
        --setenv SSL_CERT_FILE ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
        --setenv FONTCONFIG_FILE ${fonts} \
        --chdir /home/learner \
        ${payload}/lib/learnharness/learnharness --ozone-platform=wayland --disable-gpu
    '';
  };
in
{
  home.packages = [ launcher ];
  xdg.desktopEntries.learnharness = {
    name = "LearnHarness";
    comment = "Learning assistant in a restricted filesystem sandbox";
    exec = "${launcher}/bin/learnharness";
    icon = "${payload}/share/icons/hicolor/512x512/apps/learnharness.png";
    terminal = false;
    categories = [ "Education" ];
  };
}
