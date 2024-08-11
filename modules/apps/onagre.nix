{ config, ... }:
let
  palette = config.lib.stylix.colors.withHashtag;
in
{
  xdg.enable = true;
  xdg.configFile."onagre/theme.scss" = {
    text = /* scss */ ''
      .onagre {
        --exit-unfocused: false;
        height: 432px;
        width: 768px;
        --icon-theme: "Adwaita";
        --icon-size: 22px;
        /* --font-family: "Fira Code SemiBold"; */
        font-size: 24px;
        background: ${palette.base01};
        color: ${palette.base06};
        /* border-color: ${palette.base00}; */
        padding: 0px;
        .container {
          padding: 0;
          .rows {
            .row {
              .title {
                  font-size: 15px;
              }
              .description {
                font-size: 10px;
              }
              .icon {
                --icon-size: 22px;
              }
              .category-icon {
                --icon-size: 22px;
              }
            }
            .row-selected {
              background: ${palette.base02};
              .title {
                font-size: 15px;
              }
              .description {
                font-size: 10px;
              }
              .icon {
                --icon-size: 22px;
              }
              .category-icon {
                --icon-size: 22px;
              }
            }
          }
          .scrollable {
            .scroller {
              color: ${palette.base02};
            }
          }
        }
      }
    '';
  };
}
