{
  flake.nixosModules.sddm = {
    pkgs,
    username,
    config,
    ...
  }: {
    services = {
      displayManager = {
        sddm = {
          enable = true;
          wayland = {
            enable = true;
          };
          theme = "sddm-astronaut-theme";
          settings = {
            Theme = {
              CursorTheme = config.stylix.cursor.name;
            };
          };

          extraPackages = [
            pkgs.apple-cursor
          ];
        };
      };
      logind.settings.Login = {
        HandlePowerKey = "ignore";
      };
    };
    environment = {
      systemPackages = with pkgs; [
        kdePackages.qtmultimedia
        libei
        (sddm-astronaut.override {
          embeddedTheme = "black_hole";
        })
      ];
    };
  };
}
