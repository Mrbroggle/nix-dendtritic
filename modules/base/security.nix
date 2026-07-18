{
  flake.nixosModules.base = {
    pkgs,
    lib,
    username,
    ...
  }: {
    security = {
      doas = {
        enable = true;
        extraRules = [
          {
            users = [username];
            keepEnv = true;
            persist = true;
          }
        ];
      };
      sudo.extraRules = [
        {
          users = [username];
          commands = [
            {
              command = "ALL";
              options = [
              ];
            }
          ];
        }
      ];

      pam = {
        u2f = {
          enable = true;
          settings = {
            interactive = true;
            cue = true;

            origin = "pam://yubi";
            authfile = pkgs.writeText "u2f-mappings" (
              lib.concatStrings [
              ]
            );
          };
        };
        services = {
          login.kwallet = {
            enable = true;
            package = pkgs.kdePackages.kwallet-pam;
          };
          sddm.kwallet = {
            enable = true;
            package = pkgs.kdePackages.kwallet-pam;
          };
          kde = {
            allowNullPassword = true;
            kwallet = {
              enable = true;
              package = pkgs.kdePackages.kwallet-pam;
            };
          };
          /*
          fprintd.enableGnomeKeyring = true;
          sddm.text = lib.mkForce (
            lib.strings.concatLines (
              builtins.filter (x: (lib.strings.hasPrefix "auth " x) && (!lib.strings.hasInfix "fprintd" x)) (
                lib.strings.splitString "\n"
                config.security.pam.services.login.text
              )
            )
            + ''

              account   include   login
              password  substack  login
              session   include   login
            ''
          );
          */
        };
      };
    };

    environment.systemPackages = with pkgs;
    with kdePackages; [
      kwallet
      kwallet-pam
      kwalletmanager
      yubikey-manager
      cryptsetup
    ];
    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      fuse = {
        enable = true;
        userAllowOther = true;
      };
    };
    nix.settings.trusted-users = [
      "root"
      username
    ];
    /*
    systemd.services.fprintd = {
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "simple";
    };
    */
    services = {
      # gnome.gnome-keyring.enable = true;
      opensnitch.enable = true;
      openssh.enable = true;
      pcscd.enable = true;
      udev.packages = [pkgs.yubikey-personalization];
    };
  };
  flake.homeModules.base = {pkgs, ...}: {
    services.opensnitch-ui.enable = true;
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 60;
      maxCacheTtl = 120;
      pinentry.package = pkgs.pinentry-curses;
      extraConfig = ''
        ttyname $GPG_TTY
      '';
    };
  };
}
