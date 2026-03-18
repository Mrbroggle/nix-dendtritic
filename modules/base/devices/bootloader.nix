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
    }: let
      boot.loader.systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = lib.mkForce true;
      # Extract the signed shim from Fedora 41
      fedora-shim = pkgs.stdenv.mkDerivation {
        name = "fedora-shim";
        src = pkgs.fetchurl {
          url = "https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/41/Everything/x86_64/os/Packages/s/shim-x64-15.8-3.x86_64.rpm";
          sha256 = "sha256-/u6zPyp0WpaVqTeMFxSNU4al3VudXsmPZQSPOIslvS4=";
        };
        nativeBuildInputs = [pkgs.rpm pkgs.cpio];
        unpackPhase = "rpm2cpio $src | cpio -idm";
        installPhase = ''
          mkdir -p $out
          # Fedora paths inside the RPM
          cp ./boot/efi/EFI/fedora/shimx64.efi $out/bootx64.efi
          cp ./boot/efi/EFI/fedora/mmx64.efi $out/mmx64.efi
        '';
      };
    in {
      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
      };

      system.activationScripts.fedoraSecureBoot = {
        text = ''
          # Assuming your EFI partition is mounted at /boot
          TARGET_DIR="/boot/EFI/nixos"
          mkdir -p "$TARGET_DIR"

          echo "Deploying Fedora-signed Shim and Fallback binaries..."
          cp -f ${fedora-shim}/*.efi $TARGET_DIR/

          # Shim looks for 'grubx64.efi' in the same directory.
          # We ensure the GRUB binary Nix installed is correctly named.
          if [ -f "$TARGET_DIR/grubx64.efi" ]; then
            echo "GRUB binary is already in place."
          else
            # Try to locate and copy the GRUB EFI binary if it's not in the nixos folder
            cp /boot/EFI/nixos/grubx64.efi $TARGET_DIR/grubx64.efi || true
          fi
        '';
      };
    };
  };
}
