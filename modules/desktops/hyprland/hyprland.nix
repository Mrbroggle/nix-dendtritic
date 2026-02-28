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
          defaultSession = "hyprland-uwsm";
        };
        programs = {
          hyprland = {
            enable = true;
            withUWSM = true;
          };
          uwsm = {
            enable = true;
            waylandCompositors = {
              hyprland = {
                prettyName = "Hyprland";
                comment = "Hyprland managed by UWSM";
                binPath = "/run/current-system/sw/bin/Hyprland";
              };
            };
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
              "uwsm-app ${pkgs.hyprpaper}"
              "uwsm-app ${pkgs.udiskie}"
              "uwsm-app nm-applet"
              "uwsm-app clipse -listen"
              "[workspace 1 silent] ghostty"
              "uwsm-app ${pkgs.tailscale-systray}/bin/tailscale-systray"
            ];

            general = {
              layout = "scrolling";
            };

            plugin = {
              hyprscrolling = {
                column_width = "0.667";
                fullscreen_on_one_column = true;
              };
            };

            misc = {
              force_default_wallpaper = "1"; # Set to 0 or 1 to disable the anime mascot wallpapers
              disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
              focus_on_activate = true;
            };

            windowrule = [
              "match:class *, suppress_event maximise"
              "match:class com.mitchellh.ghostty, size 751 954"
              "match:class com.savedra1.clipse, float on"
              "match:class com.savedra1.clipse, size 622 652"
              "match:class com.savedra1.clipse, stay_focused on"
            ];
          };

          plugins = [
            pkgs.hyprlandPlugins.hyprscrolling
            pkgs.hyprlandPlugins.hyprsplit
          ];
        };
      };
    };
  };
}
