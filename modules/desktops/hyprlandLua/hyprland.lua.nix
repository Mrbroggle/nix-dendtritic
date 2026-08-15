{
  flake.homeModules.hyprlandLua = {
    pkgs,
    lib,
    ...
  }: {
    wayland.windowManager.hyprland.extraConfig = ''
      -- hyprland.lua — hand written, replaces programs.hypr-lua generation

      --------------------------------------------------------------------
      -- config
      --------------------------------------------------------------------

      hl.config({
        general = {
          layout = "scrolling",
          gaps_in = 5,
          gaps_out = 10,
          border_size = 1,
          resize_on_border = false,
          allow_tearing = true,
        },

        decoration = {
          rounding = 5,
          active_opacity = 1.0,
          inactive_opacity = 1.0,
          shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
          },
          blur = {
            enabled = false,
          },
        },

        animations = {
          enabled = true,
          bezier = {
            "easeOutQuint,0.23,1,0.32,1",
            "easeInOutCubic,0.65,0.05,0.36,1",
            "linear,0,0,1,1",
            "almostLinear,0.5,0.5,0.75,1.0",
            "quick,0.15,0,0.1,1",
          },
          animation = {
            "global, 1, 10, default",
            "border, 1, 5.39, easeOutQuint",
            "windows, 1, 4.79, easeOutQuint",
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%",
            "windowsOut, 1, 1.49, linear, popin 87%",
            "fadeIn, 1, 1.73, almostLinear",
            "fadeOut, 1, 1.46, almostLinear",
            "fade, 1, 3.03, quick",
            "layers, 1, 3.81, easeOutQuint",
            "layersIn, 1, 4, easeOutQuint, fade",
            "layersOut, 1, 1.5, linear, fade",
            "fadeLayersIn, 1, 1.79, almostLinear",
            "fadeLayersOut, 1, 1.39, almostLinear",
            "workspaces, 1, 1.94, almostLinear, fade",
            "workspacesIn, 1, 1.21, almostLinear, fade",
            "workspacesOut, 1, 1.94, almostLinear, fade",
          },
        },

        input = {
          sensitivity = -0.25,
          follow_mouse = 1,
          force_no_accel = false,
          touchpad = {
            disable_while_typing = false,
            natural_scroll = true,
            scroll_factor = 0.4,
          },
        },

        master = {
          new_status = "master",
        },

        misc = {
          force_default_wallpaper = 1,
          disable_hyprland_logo = true,
          focus_on_activate = true,
        },

        scrolling = {
          column_width = 0.67,
        },

        xwayland = {
          force_zero_scaling = true,
        },

        -- laptop
        monitor = {
          "eDP-1, 2880x1920@120, 0x0, 1.875",
          ", preferred, auto-left, 1",
        },

        env = {
          "GDK_SCALE,2",
          "XCURSOR_SIZE,24",
        },
      })

      --------------------------------------------------------------------
      -- window rules
      --------------------------------------------------------------------

      hl.window_rule({
        match = { class = ".*" },
        suppress_event = "maximize",
      })

      hl.window_rule({
        match = { class = "com.mitchellh.ghostty" },
        size = "751 954",
      })

      hl.window_rule({
        match = { class = "com.savedra1.clipse" },
        float = true,
        size = "622 652",
        stay_focused = true,
      })

      --------------------------------------------------------------------
      -- binds
      --------------------------------------------------------------------

      local mainMod = "SUPER"

      local terminal = "${lib.getExe pkgs.ghostty}"
      local fileManager = "${lib.getExe pkgs.kdePackages.dolphin}"
      local menu = "${lib.getExe pkgs.wofi} --show drun"
      local playerctl = "${lib.getExe pkgs.playerctl}"
      local btop = "${lib.getExe pkgs.btop}"
      local hyprshot = "${lib.getExe pkgs.hyprshot}"
      local clipse = "${lib.getExe pkgs.clipse}"
      local brightnessctl = "${lib.getExe pkgs.brightnessctl}"

      -- apps
      hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
      hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
      hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("vivaldi"))
      hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(terminal .. " --class=com.savedra1.clipse -e " .. clipse))
      hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(terminal .. " -e " .. btop))
      hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(hyprshot .. " -z -m region -o ~/Pictures/Screenshots"))

      -- window / session
      hl.bind(mainMod .. " + C", hl.dsp.window.close())
      hl.bind(mainMod .. " + M", hl.dsp.exit())
      hl.bind(mainMod .. " + G", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

      -- keyboard layout (kanata)
      hl.bind("ALT + SHIFT + SPACE", hl.dsp.exec_cmd("hyprctl switchxkblayout kanata next"))
      hl.bind("ALT + SHIFT + 1", hl.dsp.exec_cmd("hyprctl switchxkblayout kanata 0"))
      hl.bind("ALT + SHIFT + 2", hl.dsp.exec_cmd("hyprctl switchxkblayout kanata 1"))

      -- workspaces 1..10, key 0 maps to 10
      for i = 1, 10 do
        local key = (i == 10) and "0" or tostring(i)
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      -- relative workspace
      hl.bind(mainMod .. " + CTRL + L", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + CTRL + H", hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      -- focus, arrows + vim keys
      local dirs = {
        { keys = { "left", "H" }, dir = "l" },
        { keys = { "right", "L" }, dir = "r" },
        { keys = { "up", "K" }, dir = "u" },
        { keys = { "down", "J" }, dir = "d" },
      }

      for _, d in ipairs(dirs) do
        for _, k in ipairs(d.keys) do
          hl.bind(mainMod .. " + " .. k, hl.dsp.focus({ direction = d.dir }))
        end
      end

      -- resize
      local resizes = {
        { keys = { "up", "K" }, x = 0, y = -10 },
        { keys = { "down", "J" }, x = 0, y = 10 },
        { keys = { "right", "L" }, x = 10, y = 0 },
        { keys = { "left", "H" }, x = -10, y = 0 },
      }

      for _, r in ipairs(resizes) do
        for _, k in ipairs(r.keys) do
          hl.bind(mainMod .. " + SHIFT + " .. k, hl.dsp.window.resize({ x = r.x, y = r.y }))
        end
      end

      -- move / swap (scrolling layout)
      hl.bind(mainMod .. " + ALT + K", hl.dsp.window.move({ direction = "u" }))
      hl.bind(mainMod .. " + ALT + J", hl.dsp.window.move({ direction = "d" }))
      hl.bind(mainMod .. " + ALT + H", hl.dsp.window.swap({ direction = "l" }))
      hl.bind(mainMod .. " + ALT + L", hl.dsp.window.swap({ direction = "r" }))

      -- mouse drag
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())
      hl.bind(mainMod .. " + SHIFT + mouse:272", hl.dsp.window.resize())

      -- media / volume
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd(playerctl .. " next"))
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd(playerctl .. " play-pause"))
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(playerctl .. " play-pause"))
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(playerctl .. " previous"))

      -- laptop brightness
      hl.bind("code:232", hl.dsp.exec_cmd(brightnessctl .. " set -10%"))
      hl.bind("code:233", hl.dsp.exec_cmd(brightnessctl .. " set +10%"))

      --------------------------------------------------------------------
      -- autostart
      --------------------------------------------------------------------

      hl.on("hyprland.start", function()
        hl.exec_cmd("systemctl --user start hyprpolkitagent")
        hl.exec_cmd("${lib.getExe pkgs.hyprpaper}")
        hl.exec_cmd("${lib.getExe pkgs.udiskie}")
        hl.exec_cmd("${lib.getExe pkgs.networkmanagerapplet}")
        hl.exec_cmd(clipse .. " -listen")
        hl.exec_cmd(terminal)
        hl.exec_cmd("${lib.getExe pkgs.tailscale-systray}")
        hl.exec_cmd("${lib.getExe pkgs.waybar}")
        hl.exec_cmd("systemctl --user start kanshi.service")
      end)
    '';
  };
}
