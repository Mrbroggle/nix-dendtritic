{
  flake.nixosModules.sddm = {
    pkgs,
    username,
    ...
  }: {
    services = {
      xserver.enable = true;
      displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
          theme = "sddm-astronaut-theme";
          settings = {
            Autologin = {
              # User = username;
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
