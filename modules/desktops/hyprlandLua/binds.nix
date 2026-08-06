{
  flake.homeModules.hyprlandLua = {
    pkgs,
    lib,
    osConfig,
    ...
  }: let
    hl = osConfig.programs.hypr-lua.lib;
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
              handler = hl.dsp.workspace n;
            }
            {
              key = "${mainMod} + SHIFT + ${key}";
              handler = hl.dsp.movetoworkspace n;
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
                handler = hl.dsp.movefocus d.dir;
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
              handler = hl.dsp.resizeactive 0 (-10);
            }
            {
              keys = [
                "down"
                "J"
              ];
              handler = hl.dsp.resizeactive 0 10;
            }
          ];
          horizontal =
            if layout == "scrolling"
            then [
              {
                keys = [
                  "right"
                  "L"
                ];
                handler = hl.dsp.layoutmsg "colresize +conf";
              }
              {
                keys = [
                  "left"
                  "H"
                ];
                handler = hl.dsp.layoutmsg "colresize -conf";
              }
            ]
            else [
              {
                keys = [
                  "right"
                  "L"
                ];
                handler = hl.dsp.resizeactive 10 0;
              }
              {
                keys = [
                  "left"
                  "H"
                ];
                handler = hl.dsp.resizeactive (-10) 0;
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
              handler = hl.dsp.movewindow "u";
            }
            {
              key = "${mainMod} + ALT + J";
              handler = hl.dsp.movewindow "d";
            }
          ]
          ++ (
            if layout == "scrolling"
            then [
              {
                key = "${mainMod} + ALT + H";
                handler = hl.dsp.layoutmsg "swapcol l";
              }
              {
                key = "${mainMod} + ALT + L";
                handler = hl.dsp.layoutmsg "swapcol r";
              }
            ]
            else [
              {
                key = "${mainMod} + ALT + H";
                handler = hl.dsp.movewindow "l";
              }
              {
                key = "${mainMod} + ALT + L";
                handler = hl.dsp.movewindow "r";
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
            handler = hl.dsp.killactive;
          }
          {
            key = "${mainMod} + M";
            handler = hl.dsp.exit;
          }
          {
            key = "${mainMod} + G";
            handler = hl.dsp.togglefloating;
          }
          {
            key = "${mainMod} + F";
            handler = hl.dsp.fullscreen;
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
            handler = hl.dsp.workspace "e+1";
          }
          {
            key = "${mainMod} + CTRL + H";
            handler = hl.dsp.workspace "e-1";
          }
          {
            key = "${mainMod} + mouse_down";
            handler = hl.dsp.workspace "e+1";
          }
          {
            key = "${mainMod} + mouse_up";
            handler = hl.dsp.workspace "e-1";
          }
        ]
        ++ wsBinds
        ++ focusBinds
        ++ resizeBinds
        ++ moveBinds;

      bindm = [
        {
          key = "${mainMod} + mouse:272";
          handler = hl.dsp.movewindow;
        }
        {
          key = "${mainMod} + mouse:273";
          handler = hl.dsp.resizewindow;
        }
        {
          key = "${mainMod} + SHIFT + mouse:272";
          handler = hl.dsp.resizewindow;
        }
      ];

      bindel = [
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
      ];

      bindl = [
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
      ];

      gesture = [
        {
          fingers = 3;
          direction = "horizontal";
          handler = hl.dsp.workspace;
        }
      ];
    };
  };
}
