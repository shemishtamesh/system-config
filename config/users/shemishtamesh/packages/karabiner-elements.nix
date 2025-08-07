{ pkgs, ... }:
{
  home.packages = with pkgs; [ karabiner-elements ];
  xdg.configFile."karabiner/karabiner.json".text =
    # json
    ''
      {
          "profiles": [
              {
                  "devices": [
                      {
                          "identifiers": {
                              "is_keyboard": true,
                              "product_id": 620,
                              "vendor_id": 76
                          },
                          "simple_modifications": [
                              {
                                  "from": { "key_code": "left_shift" },
                                  "to": [{ "apple_vendor_top_case_key_code": "keyboard_fn" }]
                              }
                          ]
                      }
                  ],
                  "name": "Default profile",
                  "selected": true,
                  "simple_modifications": [
                      {
                          "from": { "key_code": "caps_lock" },
                          "to": [{ "key_code": "escape" }]
                      },
                      {
                          "from": { "key_code": "escape" },
                          "to": [{ "key_code": "caps_lock" }]
                      },
                      {
                          "from": { "key_code": "left_command" },
                          "to": [{ "key_code": "left_shift" }]
                      }
                  ],
                  "virtual_hid_keyboard": { "keyboard_type_v2": "ansi" }
              }
          ]
      }
    '';
}
