let
  mappings = {
    line = "<C-/>";
    block = "<C-?>";
  };
in {
  programs.nixvim.plugins.comment = {
    enable = true;
    toggler = mappings;
    opleader = mappings;
  };
}
