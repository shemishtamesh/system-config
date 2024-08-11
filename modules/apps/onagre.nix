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
        --font-family: "Fira Code SemiBold";
        font-size: 24px;
        background: ${palette.base01};
        color: ${palette.base06};
        /* border-color: ${palette.base00}; */
        padding: 0px;

        .container {
          padding: 0;

          .search {
            /* background: #f1cd1a; */
            /* color: #2c2525; */
            /* border-color: #ffffff; */
            /* border-radius: 0%; */
            /* border-width: 0px; */
            /* padding: 0; */
            /* --width: fill; */
            /* --height: fill-portion 1; */
            /* --align-x: left; */
            /* --align-y: center; */

            .plugin-hint {
              background: #3e6cce;
              color: #2c2525;
              border-color: #ffffff;
              border-radius: 0%;
              border-width: 0px;
              padding: 0;
              --width: shrink;
              --height: fill;
            }

            /* .input { */
            /*   background: #ffffff; */
            /*   color: #2c2525; */
            /*   border-color: #ffffff; */
            /*   border-radius: 0%; */
            /*   border-width: 0px; */
            /*   padding: 0; */
            /*   --width: fill; */
            /*   --height: fill; */
            /*   --text-width: fill; */
            /*   --selection-color: #1664F5A3; */
            /*   --placeholder-color: #37578FA3; */
            /*   --align-x: left; */
            /*   --align-y: center; */
            /* } */

          }

          .rows {
            /* background: #ffffff; */
            /* color: #2c2525; */
            /* border-color: #ffffff; */
            /* border-radius: 0%; */
            /* border-width: 3px; */
            /* padding: 0; */
            /* --width: fill; */
            /* --height: fill-portion 6; */

            .row {
              /* background: #de5959; */
              /* color: #2c2525; */
              /* border-color: #9535c5; */
              /* border-radius: 0%; */
              /* border-width: 3px; */
              /* padding: 10px; */
              /* --width: fill; */
              /* --height: shrink; */

              .title {
                  font-size: 15px;
              /*   font-size: 10px; */
              /*   background: #eadc1d; */
              /*   color: #2c2525; */
              /*   border-color: #ffffff; */
              /*   border-radius: 0%; */
              /*   border-width: 0px; */
              /*   padding: 0; */
              /*   --width: fill; */
              /*   --height: shrink; */
              /*   --align-x: left; */
              /*   --align-y: center; */
              }

              .description {
                font-size: 10px;
                /* background: #77d541; */
                /* color: #2c2525; */
                /* border-color: #ffffff; */
                /* border-radius: 0%; */
                /* border-width: 0px; */
                /* padding: 0; */
                /* --width: fill; */
                /* --height: shrink; */
                /* --align-x: left; */
                /* --align-y: center; */
              }

              .icon {
                --icon-size: 22px;
                /* background: #ffffff; */
                /* color: #2c2525; */
                /* border-color: #ffffff; */
                /* border-radius: 0%; */
                /* border-width: 0px; */
                /* padding: 0; */
                /* --width: shrink; */
                /* --height: shrink; */
                /* --align-x: center; */
                /* --align-y: center; */
              }

              /* .category-icon { */
              /*   --icon-size: 22px; */
              /*   background: #ffffff; */
              /*   color: #2c2525; */
              /*   border-color: #ffffff; */
              /*   border-radius: 0%; */
              /*   border-width: 0px; */
              /*   padding: 0; */
              /*   --width: shrink; */
              /*   --height: shrink; */
              /*   --align-x: center; */
              /*   --align-y: center; */
              /* } */
            }
            .row-selected {
              background: ${palette.base02};
              /* color: #2c2525; */
              /* border-color: #ffffff; */
              /* border-radius: 0%; */
              /* border-width: 0px; */
              /* padding: 10px; */
              /* --width: fill; */
              /* --height: shrink; */

              .title {
                font-size: 15px;
                /* background: #cc3737; */
                /* color: #2c2525; */
                /* border-color: #ffffff; */
                /* border-radius: 0%; */
                /* border-width: 0px; */
                /* padding: 0; */
                /* --width: fill; */
                /* --height: shrink; */
                /* --align-x: left; */
                /* --align-y: center; */
              }

              /* .description { */
              /*   font-size: 10px; */
              /*   background: #dad23e; */
              /*   color: #2c2525; */
              /*   border-color: #ffffff; */
              /*   border-radius: 0%; */
              /*   border-width: 0px; */
              /*   padding: 0; */
              /*   --width: fill; */
              /*   --height: shrink; */
              /*   --align-x: left; */
              /*   --align-y: center; */
              /* } */

              /* .icon { */
              /*   --icon-size: 20px; */
              /*   background: #ffffff; */
              /*   color: #2c2525; */
              /*   border-color: #ffffff; */
              /*   border-radius: 0%; */
              /*   border-width: 0px; */
              /*   padding: 0; */
              /*   --width: shrink; */
              /*   --height: shrink; */
              /*   --align-x: left; */
              /*   --align-y: center; */
              /* } */

              /* .category-icon { */
              /*   --icon-size: 22px; */
              /*   background: #ffffff; */
              /*   color: #2c2525; */
              /*   border-color: #ffffff; */
              /*   border-radius: 0%; */
              /*   border-width: 0px; */
              /*   padding: 0; */
              /*   --width: shrink; */
              /*   --height: shrink; */
              /*   --align-x: center; */
              /*   --align-y: center; */
              /* } */
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
