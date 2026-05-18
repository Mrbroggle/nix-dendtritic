{config, ...}: {
  flake = {
    nixosModules = {
      hyprland = {pkgs, ...}: {
        imports = with config.flake.nixosModules; [
          sddm
        ];

        home-manager.users.gradyb.imports = with config.flake.homeModules; [
          swaync
          waybar
          wlogout
        ];
        xdg.portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-hyprland
          ];
          config.common.default = "*";
        };

        services.displayManager = {
          defaultSession = "hyprland";
        };
        programs = {
          hyprland = {
            enable = true;
          };
        };

        environment = {
          systemPackages = with pkgs; [
            networkmanager
            wl-clipboard
            clipse
            hyprlock
            hyprpolkitagent
          ];
          sessionVariables = {
            NIXOS_WAYLAND = "1";
            NIXOS_OZONE_WL = "1";
          };
        };
      };

      hyprlandLaptop = _: {
        imports = [
          config.flake.nixosModules.hyprland
          {
            home-manager.users.gradyb.imports = [
              config.flake.homeModules.hyprlandLaptop
            ];
          }
        ];
      };
      hyprlandPC = _: {
        imports = [
          config.flake.nixosModules.hyprland
          {
            home-manager.users.gradyb.imports = [
              config.flake.homeModules.hyprlandPc
            ];
          }
        ];
      };
    };
    homeModules = {
      hyprlandLaptop = _: {imports = [config.flake.homeModules.hyprland];};
      hyprlandPC = _: {imports = [config.flake.homeModules.hyprland];};

      hyprland = {pkgs, ...}: {
        xdg.portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-hyprland
            pkgs.xdg-desktop-portal-gtk
          ];
          config.common.default = [
            "hyprland"
            "gtk"
          ];
        };

        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false;
          settings = {
            exec-once = [
              "systemctl --user start hyprpolkitagent"
              "${pkgs.hyprpaper}"
              "${pkgs.udiskie}"
              "nm-applet"
              "clipse -listen"
              "[workspace 1 silent] ghostty"
              "${pkgs.tailscale-systray}/bin/tailscale-systray"
              "systemctl --user start kanshi.service" # Hack because graphical target is always dead???
            ];

            plugin = {
              # hyprsplit = {
              #   num_workspaces = 10;
              # };
            };

            misc = {
              force_default_wallpaper = "1"; # Set to 0 or 1 to disable the anime mascot wallpapers
              disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
              focus_on_activate = true;
              vfr = true;
            };

            windowrule = [
              "match:class *, suppress_event maximise"
              "match:class com.mitchellh.ghostty, size 751 954"
              "match:class com.savedra1.clipse, float on"
              "match:class com.savedra1.clipse, size 622 652"
              "match:class com.savedra1.clipse, stay_focused on"
            ];
            scrolling = {
              column_width = "0.67";
            };
          };

          plugins = [
            # pkgs.hyprlandPlugins.hyprsplit ## waiting on update
          ];
        };
      };
    };
  };
}
