{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "tmux-agent-sidebar";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "hiroppy";
    repo = "tmux-agent-sidebar";
    rev = "v${version}";
    hash = lib.fakeHash;
  };

  cargoHash = lib.fakeHash;

  nativeBuildInputs = [
    pkg-config
  ];

  postInstall = ''
    pluginDir="$out/share/tmux-plugins/tmux-agent-sidebar"

    mkdir -p "$pluginDir/bin"

    cp -r . "$pluginDir"

    ln -s "$out/bin/tmux-agent-sidebar" \
      "$pluginDir/bin/tmux-agent-sidebar"

    chmod +x \
      "$pluginDir/tmux-agent-sidebar.tmux" \
      "$pluginDir/hook.sh"
  '';

  meta = {
    description = "Tmux sidebar for monitoring AI coding agents";
    homepage = "https://github.com/hiroppy/tmux-agent-sidebar";
    license = lib.licenses.mit;
    mainProgram = "tmux-agent-sidebar";
    platforms = lib.platforms.unix;
  };
}
