{
  pkgs,
  lib,
  config,
  ...
}:
let
  segments =
    if pkgs.stdenv.isLinux then
      {
        cpu = pkgs.writeShellScriptBin "cpu_segment" ''
          memory_line=$(top -b -n 1 | grep "%Cpu(s)")
          idle=$(top -b -n 1 | grep "%Cpu(s)" | grep -Po "\d*(\.\d*)? id" | awk '{print $1}')
          echo "$(echo "100 - $idle" | ${pkgs.bc}/bin/bc)% "
        '';
        memory = pkgs.writeShellScriptBin "memory_segment" ''
          memory_line=$(top -b -n 1 | grep "[KMGTPE]iB Mem")
          unit=$(echo $memory_line | grep -o "^[KMGTPE]")iB
          used=$(echo $memory_line | grep -Po '\d*(\.\d*)? used' | awk '{print $1}')
          total=$(echo $memory_line | grep -Po '\d*(\.\d*)? total' | awk '{print $1}')
          echo "$used/$total $unit "
        '';
      }
    else if pkgs.stdenv.isDarwin then
      {
        cpu = pkgs.writeShellScriptBin "cpu_segment" ''
          memory_line=$(top -l 1 | grep "CPU usage")
          idle=$(echo $memory_line | awk '{print $7}' | sed 's/%//')
          cpu_usage=$(echo "100 - $idle" | bc)
          echo "$cpu_usage% CPU"
        '';
        memory = pkgs.writeShellScriptBin "memory_segment" ''
          UNIT='G'

          memory_line=$(top -l 1 | grep "PhysMem")
          used=$(echo $memory_line | awk '{print $2}' | sed 's/[A-Za-z]//g')
          unused=$(echo $memory_line | awk '{print $8}' | sed 's/[A-Za-z]//g')

          used_unit=$(echo $memory_line | awk '{print $2}' | grep -o '[A-Za-z]')
          unused_unit=$(echo $memory_line | awk '{print $8}' | grep -o '[A-Za-z]')

          convert_memory() {
              local value=$1
              local from_unit=$2
              local to_unit=$3
              local bytes

              # Convert from the source UNIT to bytes
              case $from_unit in
                  B) bytes=$value;;
                  K) bytes=$(echo "$value * 1024" | bc);;
                  M) bytes=$(echo "$value * 1024 * 1024" | bc);;
                  G) bytes=$(echo "$value * 1024 * 1024 * 1024" | bc);;
                  T) bytes=$(echo "$value * 1024 * 1024 * 1024 * 1024" | bc);;
              esac

              # Convert from bytes to the target UNIT
              case $to_unit in
                  B) echo $bytes;;
                  K) echo $(echo "scale=2; $bytes / 1024" | bc);;
                  M) echo $(echo "scale=2; $bytes / 1024 / 1024" | bc);;
                  G) echo $(echo "scale=2; $bytes / 1024 / 1024 / 1024" | bc);;
                  T) echo $(echo "scale=2; $bytes / 1024 / 1024 / 1024 / 1024" | bc);;
              esac
          }

          used=$(convert_memory $used $used_unit $UNIT)
          unused=$(convert_memory $unused $unused_unit $UNIT)

          # total_mib=$(echo "$used_mib + $unused_mib" | bc | sed "s/0*$//g" | sed 's/\.$//g')
          used=$(echo $used | sed "s/0*$//g" | sed 's/\.$//g')
          unused=$(echo $unused | sed "s/0*$//g" | sed 's/\.$//g')

          echo " $used,  $unused ($UNIT) RAM"
        '';
      }
    else
      {
        memory = pkgs.writeShellScriptBin "memory_segment" "echo 'unsupported system'";
        cpu = pkgs.writeShellScriptBin "cpu_segment" "echo 'unsupported system'";
      };
  palette = config.lib.stylix.colors.withHashtag;
in
{
  stylix.targets.tmux.enable = true;
  programs.tmux = {
    enable = true;
    sensibleOnTop = false; # temporary fix until https://github.com/tmux-plugins/tmux-sensible/pull/75
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    shortcut = "Space";
    historyLimit = 5000;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = vim-tmux-navigator;
        extraConfig = # tmux
          ''
            # clear with vim-tmux-navigator
            bind C-l send-keys 'C-l'
          '';
      }
      {
        plugin = tmux-fzf;
        extraConfig = # tmux
          ''
            TMUX_FZF_LAUNCH_KEY="C-f"
            bind-key "a" run-shell -b "${tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/session.sh switch"
          '';

      }
      better-mouse-mode
      {
        plugin = resurrect;
        extraConfig = # tmux
          ''
            set -g @resurrect-capture-pane-contents 'on'

            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-processes '"~nvim->nvim"'
            resurrect_dir="$HOME/.local/share/tmux/resurrect"
            set -g @resurrect-dir $resurrect_dir
            set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g;s|/nix/store/.*nvim|nvim|g" $target | ${pkgs.moreutils}/bin/sponge $target'
          '';
      }
      {
        plugin = continuum;
        extraConfig = # tmux
          "set -g @continuum-restore 'on'";
      }
    ];
    extraConfig =
      with palette; # tmux
      ''
        # fix colors
        set -g default-terminal "screen-256color"

        # reload config file
        bind r source-file ~/.config/tmux/tmux.conf \; display ".tmux.conf reloaded"

        # disable suspend
        bind C-z resize-pane -Z

        # make selection mode more like vim
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection
        bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
        ${
          if lib.last (lib.splitString "-" pkgs.stdenv.system) == "darwin" then
            # tmux
            ''
              bind -T copy-mode-vi y send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
              bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
            ''
          else
            ""
        }

        # allow passthrough to let images render correctly with presenterm
        set -g allow-passthrough on

        # start new panes and windows in the same directory
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        # pane resize shortcuts
        bind -r H resize-pane -L
        bind -r J resize-pane -D
        bind -r K resize-pane -U
        bind -r L resize-pane -R

        # status line
        set -g status off
        bind -r F set-option status
        set -g status-interval 1
        set -g status-justify absolute-centre
        set -g status-left-length 100
        set -g status-right-length 100
        set -g status-left "#[bg=${base0D},fg=${base00}]#{session_name}#[bg=${base02},fg=${base0D}]"
        set -ag status-left " #{=|-24|…;s|$HOME|~|:pane_current_path}#[bg=${base00},fg=${base02}]"
        set -g status-right "#[bg=${base00},fg=${base02}]#[bg=${base02},fg=${base0D}]#(${lib.getExe segments.memory})"
        set -ag status-right " #[bg=${base0D},fg=${base00}]#(${lib.getExe segments.cpu})"
        set -g status-bg \${base00}
        set -g status-fg \${base07}
        set -g status-position top
        set -g status-keys vi

        set -ga update-environment 'KITTY_LISTEN_ON'
      '';
  };
}
