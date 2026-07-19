{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tmuxplugin-agent-sidebar";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "hiroppy";
    repo = "tmux-agent-sidebar";
    rev = "v${version}";
    hash = "sha256-NiqLgMvWbSW3M80ZUWdmmm2VkVqy8eTGcPkrOCsaasI=";
  };

  cargoHash = "sha256-mOEs2J1o9VeVOXY55r8O52TqoM2GuYU3tVoh5h+yH0s=";

  cargoTestFlags = [
    "--"
    "--skip"
    "group::tests::resolve_git_info_for_real_repo"
    "--skip"
    "group::tests::worktree_and_main_share_same_repo_root"
  ];

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

  passthru.rtp = "${placeholder "out"}/share/tmux-plugins/tmux-agent-sidebar/tmux-agent-sidebar.tmux";

  meta = {
    description = "Tmux sidebar for monitoring coding agents";
    homepage = "https://github.com/hiroppy/tmux-agent-sidebar";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "tmux-agent-sidebar";
  };
}
