{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tmuxplugin-agent-sidebar";
  version = "...";

  src = fetchFromGitHub {
    owner = "hiroppy";
    repo = "tmux-agent-sidebar";
    rev = "v${version}";
    hash = "...";
  };

  cargoHash = "...";

  postInstall = ''
    pluginDir="$out/share/tmux-plugins/tmux-agent-sidebar"

    mkdir -p "$pluginDir/bin"

    cp -r \
      agent-sidebar.conf \
      tmux-agent-sidebar.tmux \
      hook.sh \
      Cargo.toml \
      .claude-plugin \
      .opencode \
      "$pluginDir/"

    ln -s \
      "$out/bin/tmux-agent-sidebar" \
      "$pluginDir/bin/tmux-agent-sidebar"
  '';

  passthru.rtp =
    "${placeholder "out"}/share/tmux-plugins/tmux-agent-sidebar/tmux-agent-sidebar.tmux";

  meta = {
    description = "Tmux sidebar for monitoring coding agents";
    homepage = "https://github.com/hiroppy/tmux-agent-sidebar";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "tmux-agent-sidebar";
  };
}
