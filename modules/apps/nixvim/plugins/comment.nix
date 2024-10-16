let
  mappings = {
    line = "<C-/>";
    block = "<C-?>";
  };
in {
  programs.nixvim.plugins.comment = {
    enable = true;
    # settingsOptions = {
    #   toggler = mappings;
    #   # opleader = mappings;
    # };
  };
}
