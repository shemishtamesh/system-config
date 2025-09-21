{ pkgs, ... }:
{
  home.packages = with pkgs; [ tattoy ];
  xdg.configFile = {
    "tattoy/tattoy.toml".text = # toml
      ''
        show_tattoy_indicator = false

        scrollback_size = 10000

        [minimap]
        enabled = true
        animation_speed = 0.15
        # The maximum width of the minimap. It can be narrower when the scrollback is long
        # in order to maintain a consistent aspect ratio.
        max_width = 10

        [shader]
        enabled = true
        opacity = 0.75
        layer = -10
        # Whether to render the computed shader directly to the terminal. The shader pixels can still be
        # used for other purposes such as defining the foreground colour of the terminal's text,
        # see `render_shader_colours_to_text`.
        render = true
        # Use each "cell" of the shader to set the corresponding text cell's foreground colour.
        # This is most likely desirable in conjunction with the `render` option, so that the shader
        # is only visible via the terminal's text.
        render_shader_colours_to_text = false
        # Path to a Shadertoy shader on your local filesystem. Relative to the root of Tattoy's config
        # directory.
        path = "shaders/soft_shadows.glsl"

        [animated_cursor]
        enabled = true
        opacity = 1.0
        # Path to the cursor shader on your local filesystem. Relative to the root of Tattoy's
        # config directory.
        path = "shaders/cursors/smear_fade.glsl"
        # The scale of the cursor. Non-Tattoy based cursor shaders are written for cursors that are
        # rendered with lots of pixels. Whereas the number of "pixels" in a Tattoy cursor is just 2,
        # ie: "▀" and "▄". Imagine if a cursor shader had a design where it adds a single pixel
        # border to the cursor. On say a 30x60 pixel cursor, that border would look quite good. But
        # on Tattoy, that single "pixel" border suddenly makes the cursor 3 times the size! Therefore
        # by default we set the cursor size to 0.0 to avoid this oversizing. However of course, not
        # all cursor shaders will have this problem, so it may be useful to play with this value.
        cursor_scale = 0.0

        [bg_command]
        enabled = false
        # The command to run. The executable goes in the first position and then each argument must
        # be placed in its own quotes in the array.
        # Examples:
        # * Render a live-updating instance of the common monitoring application "top" in the background.
        #   `command = ["top"]`
        # * Play the "Bad Apple" video in the background.
        #   `command = ["mpv", "--really-quiet", "--vo=tct", "--volume=0", "https://www.youtube.com/watch?v=UkgK8eUdpAo"]`
        command = ["echo", "Hello World"]
        # Do you expect the command to exit or not?
        # Usually when a command exits, Tattoy shows an error notification. But you may want to render a
        # command that outputs some static content, for example to print out some ASCII-based image:
        #   `command = ["chafa", "/path/to/wallpaper.png"]`
        # Bear in mind that there's currently no config to re-run the command on terminal resize.
        expect_exit = false
        opacity = 0.75
        layer = -5

        [keybindings]
        # Whether Tattoy renders anything apart from the TTY. The TTY is always rendered,
        # so toggling this will disable all tattoys, effects, eye-candy, etc.
        toggle_tattoy = { mods = "ALT", key = "t" }
        # Toggle scolling mode whilst in scrollback.
        toggle_scrolling = { mods = "ALT", key = "s" }
        # Show/hide the minimap.
        toggle_minimap = { mods = "ALT", key = "M" }
        # Scroll up in the scrollback 
        scroll_up = { key = "UpArrow" }
        # Scroll down in the scrollback 
        scroll_down = { key = "DownArrow" }
        # Exit scrolling mode
        scroll_exit = { key = "Escape" }
        # Cycle to previous shader in user's shader config directory
        shader_prev = { mods = "ALT", key = "9" }
        # Cycle to next shader in user's shader config directory
        shader_next = { mods = "ALT", key = "0" }
      '';
  };
}
