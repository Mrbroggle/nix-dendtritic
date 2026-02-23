{
  flake.homeModules.waybar = {lib, ...}: {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          reload_style_on_change = true;
          modules-left = [
            "clock"
            "tray"
            "custom/xkb-layout"
          ];
          modules-center = [
            "hyprland/workspaces"
          ];
          modules-right = [
            "cpu"
            "memory"
            "temperature"
            "bluetooth"
            "network"
            "battery"
            "custom/notification"
          ];
          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              active = "";
              default = "";
              empty = "";
            };
            persistent-workspaces = {
              "*" = [
                1
                2
                3
                4
                5
              ];
            };
          };
          "custom/notification" = {
            tooltip = false;
            format = "";
            on-click = "swaync-client -t -sw";
            escape = true;
          };
          "custom/xkb-layout" = {
            tooltip = false;
            format = "  {text}  ";
            exec = "nc localhost 6666 | jq -r --unbuffered --compact-output '.LayerChange.new'";
          };
          clock = {
            format = "{:%H:%M:%S} ";
            interval = 1;
            tooltip-format = "<tt>{calendar}</tt>";
            calendar = {
              format = {
                today = "<span color='#fAfBfC'><b>{}</b></span>";
              };
            };
            actions = {
              on-click-right = "shift_down";
              on-click = "shift_up";
            };
          };
          network = {
            format-wifi = " ";
            format-ethernet = "";
            format-disconnected = "";
            tooltip-format-disconnected = "Error";
            tooltip-format-wifi = "{essid} ({signalStrength}%)  ";
            tooltip-format-ethernet = "{ifname} 🖧";
            on-click = "ghostty -e nmtui";
          };
          bluetooth = {
            format-on = "󰂯";
            format-off = "BT-off";
            format-disabled = "󰂲";
            format-connected-battery = "{device_battery_percentage}% 󰂯";
            format-alt = "{device_alias} 󰂯";
            tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\n{device_address}";
            tooltip-format-enumerate-connected-battery = "{device_alias}\n{device_address}\n{device_battery_percentage}%";
            on-click-right = "blueman-manager";
          };
          battery = {
            interval = 30;
            states = {
              good = 95;
              warning = 30;
              critical = 20;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% 󰂄";
            format-plugged = "{capacity}% 󰂄 ";
            format-alt = "{time} {icon}";
            format-icons = [
              "󰁻"
              "󰁼"
              "󰁾"
              "󰂀"
              "󰂂"
              "󰁹"
            ];
          };
          cpu = {
            format = "{usage}% 󰻠";
            tooltip = true;
          };
          memory = {
            tooltip = false;
            format = "{percentage}% ";
          };
          temperature = {
            tooltip = false;
            critical-threshold = 80;
            format = "{temperatureC}°C ";
          };
          tray = {
            icon-size = 14;
            spacing = 10;
          };
        };
      };
      style = lib.mkAfter ''
        * {
          font-size: 15px;
          font-family: "CodeNewRoman Nerd Font Propo";
        }
        window#waybar {
          all: unset;
        }
        .modules-left {
          padding: 7px;
          margin: 10 0 5 10;
          border-radius: 10px;
          background: alpha(@base00, 0.6);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, 0.6);
        }
        .modules-center {
          padding: 7px;
          margin: 10 0 5 0;
          border-radius: 10px;
          background: alpha(@base00, 0.6);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, 0.6);
        }
        .modules-right {
          padding: 7px;
          margin: 10 10 5 0;
          border-radius: 10px;
          background: alpha(@base00, 0.6);
          box-shadow: 0px 0px 2px rgba(0, 0, 0, 0.6);
        }
        tooltip {
          background: @base00;
          color: @base07;
        }
        #clock:hover,
        #custom-pacman:hover,
        #custom-notification:hover,
        #bluetooth:hover,
        #network:hover,
        #battery:hover,
        #cpu:hover,
        #memory:hover,
        #temperature:hover {
          transition: all 0.3s ease;
          color: @base09;
        }
        #custom-notification {
          padding: 0px 5px;
          transition: all 0.3s ease;
          color: @base07;
        }
        #clock {
          padding: 0px 5px;
          color: @base07;
          transition: all 0.3s ease;
        }
        #custom-pacman {
          padding: 0px 5px;
          transition: all 0.3s ease;
          color: @base07;
        }
        #workspaces {
          padding: 0px 5px;
        }
        #workspaces button {
          all: unset;
          padding: 0px 5px;
          color: alpha(@base09, 0.4);
          transition: all 0.2s ease;
        }
        #workspaces button:hover {
          color: rgba(0, 0, 0, 0);
          border: none;
          text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 0.5);
          transition: all 1s ease;
        }
        #workspaces button.active {
          color: @base09;
          border: none;
          text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.5);
        }
        #workspaces button.empty {
          color: rgba(0, 0, 0, 0);
          border: none;
          text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 0.2);
        }
        #workspaces button.empty:hover {
          color: rgba(0, 0, 0, 0);
          border: none;
          text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 0.5);
          transition: all 1s ease;
        }
        #workspaces button.empty.active {
          color: @base09;
          border: none;
          text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.5);
        }
        #bluetooth {
          padding: 0px 5px;
          transition: all 0.3s ease;
          color: @base07;
        }
        #network {
          padding: 0px 5px;
          transition: all 0.3s ease;
          color: @base07;
        }
        #battery {
          padding: 0px 5px;
          transition: all 0.3s ease;
          color: @base07;
        }
        #battery.charging {
          color: #26a65b;
        }

        #battery.warning:not(.charging) {
          color: #ffbe61;
        }

        #battery.critical:not(.charging) {
          color: #f53c3c;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
        #group-expand {
          padding: 0px 5px;
          transition: all 0.3s ease;
        }
        #custom-expand {
          padding: 0px 5px;
          color: alpha(@base04, 0.2);
          text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.7);
          transition: all 0.3s ease;
        }
        #custom-expand:hover {
          color: rgba(255, 255, 255, 0.2);
          text-shadow: 0px 0px 2px rgba(255, 255, 255, 0.5);
        }
        #custom-colorpicker {
          padding: 0px 5px;
        }
        #cpu,
        #memory,
        #temperature {
          padding: 0px 5px;
          transition: all 0.3s ease;
          color: @base07;
        }
        #custom-endpoint {
          color: transparent;
          text-shadow: 0px 0px 1.5px rgba(0, 0, 0, 1);
        }
        #tray {
          padding: 0px 5px;
          transition: all 0.3s ease;
        }
        #tray menu * {
          padding: 0px 5px;
          transition: all 0.3s ease;
        }

        #tray menu separator {
          padding: 0px 5px;
          transition: all 0.3s ease;
        }
      '';
    };
  };
  flake.homeModules.hyprland = _: {
    wayland.windowManager.hyprland.settings.exec-once = ["waybar"];
  };
}
