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
      environment.systemPackages = with pkgs; [
        sbctl
        sbsigntool
        efibootmgr
      ];

      boot.loader = {
        systemd-boot.enable = lib.mkForce false;
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
          efiInstallAsRemovable = false;
        };
      };

      system.activationScripts.secureBootSigning = {
        text = ''
          if [ -d "/boot/EFI/NixOS-boot" ]; then
            EFI_DIR="/boot/EFI/NixOS-boot"
          elif [ -d "/boot/EFI/nixos" ]; then
            EFI_DIR="/boot/EFI/nixos"
          else
            echo "Could not find a NixOS EFI directory. Skipping."
            exit 0
          fi

          echo "Found EFI files in $EFI_DIR. Signing..."

          if [ -f "$EFI_DIR/grubx64.efi" ]; then
            ${pkgs.sbctl}/bin/sbctl sign -s "$EFI_DIR/grubx64.efi"
          fi

          for k in "$EFI_DIR"/kernel-*.efi; do
            [ -f "$k" ] && ${pkgs.sbctl}/bin/sbctl sign -s "$k"
          done

          EFI_PATH=$(echo "$EFI_DIR/grubx64.efi" | sed 's|/boot||' | tr '/' '\\')

          if ! ${pkgs.efibootmgr}/bin/efibootmgr | grep -q "NixOS-GRUB-Signed"; then
            ${pkgs.efibootmgr}/bin/efibootmgr -c -d /dev/nvme0n1 -p 1 -L "NixOS-GRUB-Signed" -l "$EFI_PATH"
          fi
        '';
      };
    };
  };
}
