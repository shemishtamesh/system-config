let
  mappings = {
    line = "<C-/>";
    block = "<C-?>";
  };
in
{
  programs.nixvim.plugins.comment = {
    enable = true;
    settings = {
      toggler = mappings;
      opleader = mappings;
    };
  };
}
