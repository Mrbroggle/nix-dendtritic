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
          if [ -d "/boot/EFI/nixos" ]; then
            echo "Auto-signing NixOS EFI binaries with sbctl..."

            ${pkgs.sbctl}/bin/sbctl sign -s /boot/EFI/nixos/grubx64.efi

            for k in /boot/EFI/nixos/kernel-*.efi; do
              if [ -f "$k" ]; then
                ${pkgs.sbctl}/bin/sbctl sign -s "$k"
              fi
            done
          fi

          if ! ${pkgs.efibootmgr}/bin/efibootmgr | grep -q "NixOS-GRUB-Signed"; then
            echo "Boot entry missing. Creating NixOS-GRUB-Signed..."
            # Change /dev/nvme0n1 and -p 1 to match your actual EFI partition
            ${pkgs.efibootmgr}/bin/efibootmgr -c -d /dev/nvme0n1 -p 1 -L "NixOS-GRUB-Signed" -l "$GRUB_PATH"
          else
            echo "Boot entry 'NixOS-GRUB-Signed' already exists."
          fi

          NEW_ENTRY=$(${pkgs.efibootmgr}/bin/efibootmgr | grep "NixOS-GRUB-Signed" | cut -c 5-8)
          if [ -n "$NEW_ENTRY" ]; then
            ${pkgs.efibootmgr}/bin/efibootmgr -o "$NEW_ENTRY"
          fi
        '';
      };
    };
  };
}
