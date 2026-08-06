{config, ...}: {
  flake = {
    nixosModules = {
      hyprlandLua = {pkgs, ...}: {
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
            pkgs.kdePackages.kwallet
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

      hyprlandLaptopLua = _: {
        imports = [
          config.flake.nixosModules.hyprlandLua
          {
            home-manager.users.gradyb.imports = [
              config.flake.homeModules.hyprlandLaptopLua
              config.flake.homeModules.hyprlandLaptopLuaDisplays
            ];
          }
        ];
      };
      hyprlandPCLua = _: {
        imports = [
          config.flake.nixosModules.hyprlandLua
          {
            home-manager.users.gradyb.imports = [
              config.flake.homeModules.hyprlandPCLua
              config.flake.homeModules.hyprlandPCLuaDisplays
            ];
          }
        ];
      };
    };

    homeModules = {
      hyprlandLaptopLua = _: {imports = [config.flake.homeModules.hyprlandLua];};
      hyprlandPCLua = _: {imports = [config.flake.homeModules.hyprlandLua];};
      hyprlandLua = {
        pkgs,
        config,
        lib,
        ...
      }: let
        hl = config.programs.hypr-lua.lib;
      in {
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
          configType = "lua";
          systemd.enable = false;
        };

        programs.hypr-lua = {
          enable = true;

          on.hyprland.start = [
            (hl.exec_cmd "systemctl --user start hyprpolkitagent")
            (hl.exec_cmd "${lib.getExe pkgs.hyprpaper}")
            (hl.exec_cmd "${lib.getExe pkgs.udiskie}")
            (hl.exec_cmd "nm-applet")
            (hl.exec_cmd "clipse -listen")
            (hl.exec_cmd "ghostty")
            (hl.exec_cmd "${lib.getExe pkgs.tailscale-systray}")
            (hl.exec_cmd "${lib.getExe pkgs.waybar}")
            (hl.exec_cmd "systemctl --user start kanshi.service") # Hack because graphical target is always dead???
          ];
          settings.config = {
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
            scrolling = {
              column_width = "0.67";
            };
          };
        };
      };
    };
  };
}
