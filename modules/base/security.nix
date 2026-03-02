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
          login.enableGnomeKeyring = true;
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

    environment.systemPackages = with pkgs; [
      yubikey-manager
      cryptsetup
    ];
    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
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
      gnome.gnome-keyring.enable = true;
      opensnitch.enable = true;
      openssh.enable = true;
      pcscd.enable = true;
      udev.packages = [pkgs.yubikey-personalization];
    };
  };
  flake.homeModules.base = {pkgs, ...}: {
    services.opensnitch-ui.enable = true;
    programs.gpg = {
      enable = true;

      # https://support.yubico.com/hc/en-us/articles/4819584884124-Resolving-GPG-s-CCID-conflicts
      scdaemonSettings = {
        disable-ccid = true;
      };

      # https://github.com/drduh/config/blob/master/gpg.conf
      settings = {
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        fixed-list-mode = true;
        no-comments = true;
        no-emit-version = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;
        require-cross-certification = true;
        no-symkey-cache = true;
        use-agent = true;
        throw-keyids = true;
      };
    };

    services.gpg-agent = {
      enable = true;

      # https://github.com/drduh/config/blob/master/gpg-agent.conf
      defaultCacheTtl = 60;
      maxCacheTtl = 120;
      pinentry.package = pkgs.pinentry-curses;
      extraConfig = ''
        ttyname $GPG_TTY
      '';
    };
  };
}
