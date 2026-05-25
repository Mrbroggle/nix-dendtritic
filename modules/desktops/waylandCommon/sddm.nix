{
  flake.nixosModules.sddm = {
    pkgs,
    username,
    ...
  }: {
    services = {
      xserver = {
        enable = true;

        displayManager.setupCommands = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init\n";
      };
      displayManager = {
        sddm = {
          enable = true;
          wayland = {
            enable = true;
            compositor = "kwin";
          };
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
