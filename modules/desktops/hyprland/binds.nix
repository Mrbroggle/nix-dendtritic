{
  flake.homeModules.hyprland = {
    pkgs,
    lib,
    osConfig,
    ...
  }: let
    layout = "scrolling";
  in {
    wayland.windowManager.hyprland.settings = {
      "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier

      "$terminal" = "${lib.getExe pkgs.ghostty}";

      "$playerctl" = "${lib.getExe pkgs.playerctl}";
      "$fileManager" = "${lib.getExe' pkgs.kdePackages.dolphin "dolphin"}";
      "$menu" = "${lib.getExe pkgs.wofi} --show drun";

      general.layout = layout;

      bind =
        [
          "$mainMod, Q, exec, $terminal"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, G, togglefloating,"
          "$mainMod, R, exec, $menu"

          "$mainMod, B, exec, vivaldi"
          "$mainMod, P, pseudo, # dwindle"
          "$mainMod, U, togglesplit, # dwindle"

          "$mainMod, F, fullscreen,"
          "$mainMod SHIFT, S, exec, ${lib.getExe pkgs.hyprshot} -z -m region -o ~/Pictures/Screenshots"
          "$mainMod, V, exec, $terminal --class=com.savedra1.clipse -e clipse"
          "CONTROL_SHIFT, Escape, exec, ${lib.getExe pkgs.ghostty} -e \"${lib.getExe pkgs.btop}\""

          "ALT SHIFT, SPACE, exec, hyprctl switchxkblayout kanata next"
          "ALT SHIFT, 1, exec, hyprctl switchxkblayout kanata 0"
          "ALT SHIFT, 2, exec, hyprctl switchxkblayout kanata 1"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"

          "$mainMod CTRL, L, workspace, e+1"
          "$mainMod CTRL, H, workspace, e-1"
          # "$mainMod SHIFT, 1, split:movetoworkspace, 1"
          # "$mainMod SHIFT, 2, split:movetoworkspace, 2"
          # "$mainMod SHIFT, 3, split:movetoworkspace, 3"
          # "$mainMod SHIFT, 4, split:movetoworkspace, 4"
          # "$mainMod SHIFT, 5, split:movetoworkspace, 5"
          # "$mainMod SHIFT, 6, split:movetoworkspace, 6"
          # "$mainMod SHIFT, 7, split:movetoworkspace, 7"
          # "$mainMod SHIFT, 8, split:movetoworkspace, 8"
          # "$mainMod SHIFT, 9, split:movetoworkspace, 9"
          # "$mainMod SHIFT, 0, split:movetoworkspace, 10"
          # "$mainMod, mouse_down, split:workspace, e+1"
          # "$mainMod, mouse_up, split:workspace, e-1"

          "$mainMod 1, workspace, 1"
          "$mainMod 2, workspace, 2"
          "$mainMod 3, workspace, 3"
          "$mainMod 4, workspace, 4"
          "$mainMod 5, workspace, 5"
          "$mainMod 6, workspace, 6"
          "$mainMod 7, workspace, 7"
          "$mainMod 8, workspace, 8"
          "$mainMod 9, workspace, 9"
          "$mainMod 0, workspace, 10"

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ]
        ++ (
          if (layout == "scrolling")
          then [
            "$mainMod SHIFT, up, resizeactive, 0 -10"
            "$mainMod SHIFT, down, resizeactive, 0 10"
            "$mainMod SHIFT, right, layoutmsg, colresize +conf"
            "$mainMod SHIFT, left, layoutmsg, colresize -conf"

            "$mainMod SHIFT, K, resizeactive, 0 -10"
            "$mainMod SHIFT, J, resizeactive, 0 10"
            "$mainMod SHIFT, L, layoutmsg, colresize +conf"
            "$mainMod SHIFT, H, layoutmsg, colresize -conf"

            "$mainMod ALT, K, movewindow, u"
            "$mainMod ALT, J, movewindow, d"
            "$mainMod ALT, H, layoutmsg, swapcol l"
            "$mainMod ALT, L, layoutmsg, swapcol r"
          ]
          else [
            "$mainMod SHIFT, up, resizeactive, 0 -10"
            "$mainMod SHIFT, down, resizeactive, 0 10"
            "$mainMod SHIFT, right, resizeactive, 10 0"
            "$mainMod SHIFT, left, resizeactive, -10 0"

            "$mainMod SHIFT, L, resizeactive, 10 0"
            "$mainMod SHIFT, H, resizeactive, -10 0"
            "$mainMod SHIFT, K, resizeactive, 0 -10"
            "$mainMod SHIFT, J, resizeactive, 0 10"

            "$mainMod ALT, K, movewindow, u"
            "$mainMod ALT, J, movewindow, d"
            "$mainMod ALT, H, movewindow, l"
            "$mainMod ALT, L, movewindow, r"
          ]
        );

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "$mainMod SHIFT, mouse:272, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      bindl = [
        ", XF86AudioNext, exec, $playerctl next"
        ", XF86AudioPause, exec, $playerctl play-pause"
        ", XF86AudioPlay, exec, $playerctl play-pause"
        ", XF86AudioPrev, exec, $playerctl previous"
      ];
      gesture = [
        "3, horizontal, workspace"
      ];
    };
  };
}
