{config, ...}: {
  flake = {
    nixosModules = {
      hyprlandLua = {pkgs, ...}: {
        imports = with config.flake.nixosModules; [
          sddm
          {
            home-manager.users.gradyb.imports = [
              config.flake.homeModules.hyprlandLua
            ];
          }
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
    };

    homeModules.hyprlandLua = {
      pkgs,
      lib,
      ...
    }: {
      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        systemd.enable = false;
      };
    };
  };
}
