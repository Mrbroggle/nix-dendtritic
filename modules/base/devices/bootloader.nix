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
        sbsigntool
        efibootmgr
      ];

      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        efiInstallAsRemovable = false;
      };

      system.activationScripts.secureBootSigning = {
        text = ''
          # 1. SIGNING LOGIC
          KEY="/etc/secureboot/keys/db/db.key"
          CERT="/etc/secureboot/keys/db/db.pem"
          EFI_DIR="/boot/EFI/nixos"
          GRUB_PATH="/EFI/nixos/grubx64.efi"

          if [ -f "$KEY" ] && [ -d "$EFI_DIR" ]; then
            echo "Auto-signing EFI binaries..."
            for f in "$EFI_DIR"/*.efi; do
              # Skip the Shim if it exists (it's already signed by MS)
              [[ "$f" == *"bootx64.efi"* ]] && continue
              ${pkgs.sbsigntool}/bin/sbsign --key "$KEY" --cert "$CERT" --output "$f" "$f"
            done
          fi

          # 2. BOOT ENTRY LOGIC
          # Check if an entry named "NixOS-GRUB-Signed" already exists
          if ! ${pkgs.efibootmgr}/bin/efibootmgr | grep -q "NixOS-GRUB-Signed"; then
            echo "Boot entry missing. Creating NixOS-GRUB-Signed..."
            # Change /dev/nvme0n1 and -p 1 to match your actual EFI partition
            ${pkgs.efibootmgr}/bin/efibootmgr -c -d /dev/nvme0n1 -p 1 -L "NixOS-GRUB-Signed" -l "$GRUB_PATH"
          else
            echo "Boot entry 'NixOS-GRUB-Signed' already exists."
          fi

          # 3. FORCE BOOT ORDER
          # Ensures our signed GRUB is always at the top (0000 usually)
          # This prevents BIOS from defaulting back to systemd-boot (0005)
          NEW_ENTRY=$(${pkgs.efibootmgr}/bin/efibootmgr | grep "NixOS-GRUB-Signed" | cut -c 5-8)
          if [ -n "$NEW_ENTRY" ]; then
            ${pkgs.efibootmgr}/bin/efibootmgr -o "$NEW_ENTRY"
          fi
        '';
      };
    };
  };
}
