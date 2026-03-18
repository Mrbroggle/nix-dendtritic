{
  inputs,
  config,
  ...
}: {
  # These are the "Top Level" inputs from your flake
  flake.nixosModules = {
    secureSystemd-boot = {
      pkgs,
      lib,
      ...
    }: {
      imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
        config.flake.nixosModules.secureBootLoader
      ];
      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      environment.systemPackages = [
        pkgs.sbctl
      ];
    };

    systemd-boot = _: {
      boot.loader.systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
    };

    secureGrub = {
      pkgs,
      lib,
      ...
    }: {
      environment.systemPackages = [
        pkgs.sbctl
      ];
      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        efiInstallAsRemovable = false;
      };

      system.activationScripts.signGrub = {
        text = ''
          # Path to the keys created by sbctl
          KEY="/etc/secureboot/keys/db/db.key"
          CERT="/etc/secureboot/keys/db/db.pem"
          GRUB_BIN="/boot/EFI/nixos/grubx64.efi"

          if [ -f "$KEY" ] && [ -f "$GRUB_BIN" ]; then
            echo "Signing GRUB binary with custom keys..."
            # Sign the binary in-place
            ${pkgs.sbsigntool}/bin/sbsign --key "$KEY" --cert "$CERT" --output "$GRUB_BIN" "$GRUB_BIN"
          else
            echo "Required keys or GRUB binary missing. Skipping signature."
          fi
        '';
      };
    };
  };
}
