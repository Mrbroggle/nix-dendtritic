{
  flake.nixosModules.sddm = {pkgs, ...}: {
    services = {
      xserver.enable = true;
      displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
          theme = "sddm-astronaut-theme";
          settings = {
            Autologin = {
              # User = "gradyb";
            };
          };
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
