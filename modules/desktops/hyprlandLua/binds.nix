{
  flake.homeModules.hyprlandLua = {
    pkgs,
    lib,
    config,
    ...
  }: let
    hl = config.programs.hypr-lua.lib;
    layout = "scrolling";
  in {
    programs.hypr-lua = let
      mainMod = "SUPER";
      terminal = "${lib.getExe pkgs.ghostty}";
      playerctl = "${lib.getExe pkgs.playerctl}";
      fileManager = "${lib.getExe' pkgs.kdePackages.dolphin "dolphin"}";
      menu = "${lib.getExe pkgs.wofi} --show drun";
    in {
      bind = let
        # workspace switch / move, 1..9 then 0 for 10
        wsBinds = lib.concatMap (
          n: let
            key =
              if n == 10
              then "0"
              else toString n;
          in [
            {
              key = "${mainMod} + ${key}";
              handler = lib.generators.mkLuaInline "hl.dsp.workspace.move({workspace=${toString n}})";
            }
            {
              key = "${mainMod} + SHIFT + ${key}";
              handler = lib.generators.mkLuaInline "hl.dsp.window.move({workspace=${toString n}})";
            }
          ]
        ) (lib.range 1 10);

        # focus binds for both arrow and vim keys
        dirs = [
          {
            keys = [
              "left"
              "H"
            ];
            dir = "l";
          }
          {
            keys = [
              "right"
              "L"
            ];
            dir = "r";
          }
          {
            keys = [
              "up"
              "K"
            ];
            dir = "u";
          }
          {
            keys = [
              "down"
              "J"
            ];
            dir = "d";
          }
        ];

        focusBinds =
          lib.concatMap (
            d:
              map (k: {
                key = "${mainMod} + ${k}";
                handler =
                  lib.generators.mkLuaInline "hl.dsp.focus({ direction = ${d.dir} })";
              })
              d.keys
          )
          dirs;

        # resize / move, arrow + vim variants, layout dependent
        resizeBinds = let
          vertical = [
            {
              keys = [
                "up"
                "K"
              ];
              handler =
                lib.generators.mkLuaInline "hl.dsp.window.resize({x=0, y=-10 })";
            }
            {
              keys = [
                "down"
                "J"
              ];
              handler =
                lib.generators.mkLuaInline "hl.dsp.window.resize({x=0, y=10 })";
            }
          ];
          horizontal = [
            {
              keys = [
                "right"
                "L"
              ];

              handler =
                lib.generators.mkLuaInline "hl.dsp.window.resize({x=10, y=0 })";
            }
            {
              keys = [
                "left"
                "H"
              ];
              handler =
                lib.generators.mkLuaInline "hl.dsp.window.resize({x=-10, y=0 })";
            }
          ];
        in
          lib.concatMap (
            b:
              map (k: {
                key = "${mainMod} + SHIFT + ${k}";
                inherit (b) handler;
              })
              b.keys
          ) (vertical ++ horizontal);

        moveBinds =
          [
            {
              key = "${mainMod} + ALT + K";
              handler = lib.generators.mkLuaInline "hl.dsp.window.move({ direction = u })";
            }
            {
              key = "${mainMod} + ALT + J";
              handler = lib.generators.mkLuaInline "hl.dsp.window.move({ direction = d })";
            }
          ]
          ++ (
            if layout == "scrolling"
            then [
              {
                key = "${mainMod} + ALT + H";
                handler = lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = l })";
              }
              {
                key = "${mainMod} + ALT + L";
                handler = lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = r })";
              }
            ]
            else [
              {
                key = "${mainMod} + ALT + H";
                handler = lib.generators.mkLuaInline "hl.dsp.window.move({ direction = l })";
              }
              {
                key = "${mainMod} + ALT + L";
                handler = lib.generators.mkLuaInline "hl.dsp.window.move({ direction = r })";
              }
            ]
          );
      in
        [
          # apps
          {
            key = "${mainMod} + Q";
            handler = hl.dsp.exec_cmd "${terminal}";
          }
          {
            key = "${mainMod} + E";
            handler = hl.dsp.exec_cmd "${fileManager}";
          }
          {
            key = "${mainMod} + R";
            handler = hl.dsp.exec_cmd "${menu}";
          }
          {
            key = "${mainMod} + B";
            handler = hl.dsp.exec_cmd "vivaldi";
          }
          {
            key = "${mainMod} + V";
            handler = hl.dsp.exec_cmd "${terminal} --class=com.savedra1.clipse -e clipse";
          }
          {
            key = "CTRL + SHIFT + Escape";
            handler = hl.dsp.exec_cmd "${terminal} -e ${lib.getExe pkgs.btop}";
          }
          {
            key = "${mainMod} + SHIFT + S";
            handler = hl.dsp.exec_cmd "${lib.getExe pkgs.hyprshot} -z -m region -o ~/Pictures/Screenshots";
          }

          # window / session
          {
            key = "${mainMod} + C";
            handler = hl.dsp.window.close;
          }
          {
            key = "${mainMod} + M";
            handler = hl.dsp.exit;
          }
          {
            key = "${mainMod} + G";
            handler = lib.generators.mkLuaInline "hl.dsp.window.float({ action = 'toggle' })";
          }
          {
            key = "${mainMod} + F";
            handler = lib.generators.mkLuaInline "hl.dsp.window.fullscreen({ action = 'toggle' })";
          }

          # keyboard layout (kanata)
          {
            key = "ALT + SHIFT + SPACE";
            handler = hl.dsp.exec_cmd "hyprctl switchxkblayout kanata next";
          }
          {
            key = "ALT + SHIFT + 1";
            handler = hl.dsp.exec_cmd "hyprctl switchxkblayout kanata 0";
          }
          {
            key = "ALT + SHIFT + 2";
            handler = hl.dsp.exec_cmd "hyprctl switchxkblayout kanata 1";
          }

          # relative workspace
          {
            key = "${mainMod} + CTRL + L";
            handler = lib.generators.mkLuaInline "hl.dsp.workspace.move({ workspace = \"e+1\" })";
          }
          {
            key = "${mainMod} + CTRL + H";
            handler = lib.generators.mkLuaInline "hl.dsp.workspace.move({ workspace = \"e-1\" })";
          }
          {
            key = "${mainMod} + mouse_down";
            handler = lib.generators.mkLuaInline "hl.dsp.workspace.move({ workspace = \"e+1\" })";
          }
          {
            key = "${mainMod} + mouse_up";
            handler = lib.generators.mkLuaInline "hl.dsp.workspace.move({ workspace = \"e-1\" })";
          }
          {
            key = "XF86AudioRaiseVolume";
            handler = hl.dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          }
          {
            key = "XF86AudioLowerVolume";
            handler = hl.dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          }
          {
            key = "XF86AudioMute";
            handler = hl.dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          }
          {
            key = "XF86AudioMicMute";
            handler = hl.dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          }
          {
            key = "XF86AudioNext";
            handler = hl.dsp.exec_cmd "${playerctl} next";
          }
          {
            key = "XF86AudioPause";
            handler = hl.dsp.exec_cmd "${playerctl} play-pause";
          }
          {
            key = "XF86AudioPlay";
            handler = hl.dsp.exec_cmd "${playerctl} play-pause";
          }
          {
            key = "XF86AudioPrev";
            handler = hl.dsp.exec_cmd "${playerctl} previous";
          }

          {
            key = "${mainMod} + mouse:272";
            handler = hl.dsp.window.drag;
          }
          {
            key = "${mainMod} + mouse:273";

            handler =
              lib.generators.mkLuaInline "hl.dsp.window.resize({x=0, y=-10 })";
          }
          {
            key = "${mainMod} + SHIFT + mouse:272";
            handler =
              lib.generators.mkLuaInline "hl.dsp.window.resize({x=0, y=10 })";
          }
        ]
        ++ wsBinds
        ++ focusBinds
        ++ resizeBinds
        ++ moveBinds;

      settings.config = {
        gesture = [
          {
            fingers = 3;
            direction = "horizontal";
            handler = lib.generators.mkLuaInline "hl.dsp.window.move({})";
          }
        ];
      };
    };
  };
}
