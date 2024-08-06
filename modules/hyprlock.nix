{ ... }:

{
    programs.hyprlock.enable = true;
    programs.hyprlock.settings = {
        general = {
            grace = 60;
        };
    };
}
