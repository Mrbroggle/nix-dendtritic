{
  flake.homeModules.swaync = _: {
    services.swaync = {
      enable = true;
      settings = {
        "$schema" = "/etc/xdg/swaync/configSchema.json";
        positionX = "right";
        positionY = "bottom";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        cssPriority = "application";
        control-center-width = 350;
        control-center-margin-top = 6;
        control-center-margin-bottom = 6;
        control-center-margin-right = 6;
        control-center-margin-left = 6;
        notification-2fa-action = true;
        notification-inline-replies = true;
        notification-window-width = 350;
        notification-icon-size = 60;
        notification-body-image-height = 180;
        notification-body-image-width = 180;
        timeout = 12;
        timeout-low = 6;
        timeout-critical = 1;
        fit-to-screen = true;
        keyboard-shortcuts = true;
        image-visibility = "when available";
        transition-time = 200;
        hide-on-clear = false;
        hide-on-action = true;
        script-fail-notify = true;
        widgets = [
          "mpris"
          "title"
          "notifications"
          "volume"
          "backlight"
          "buttons-grid"
        ];
        widget-config = {
          title = {
            text = "Notification Center";
            clear-all-button = true;
            button-text = "󰆴";
          };
          label = {
            max-lines = 1;
            text = "Notification Center!";
          };
          mpris = {
            image-size = 80;
            image-radius = 0;
          };
          volume = {
            label = "󰕾 ";
          };
          backlight = {
            label = "󰃟 ";
            subsystem = "backlight";
            device = "amdgpu_bl1";
          };
          buttons-grid = {
            actions = [
              {
                label = "󰕾";
                command = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
                type = "toggle";
              }
              {
                label = "󰍬";
                command = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
                type = "toggle";
              }
              {
                label = "";
                command = "ghostty nmtui";
              }
              {
                label = "";
                command = "blueman-manager";
              }
              {
                label = "󰤄";
                command = "swaync-client -d";
                type = "toggle";
              }
              {
                label = "󰀟";
                command = "gnome-network-displays";
              }
              {
                label = "";
                command = "ghostty bash -i -c 'btop'";
              }
              {
                label = "";
                command = "hyprlock";
              }
              {
                label = "";
                command = "reboot";
              }
              {
                label = "";
                command = "shutdown now";
              }
            ];
          };
        };
      };
    };
  };

  flake.homeModules.hyprland = _: {
    wayland.windowManager.hyprland.settings = {
      exec-once = ["swaync"];
      bind = [
        "$mainMod, N, exec, swaync-client -t"
      ];
    };
  };
}
