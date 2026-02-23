{
  flake.nixosModules.display = {pkgs, ...}: {
    boot.blacklistedKernelModules = [
      "hid_sensor_hub"
    ];

    environment.systemPackages = with pkgs; [
      brightnessctl
      bc
    ];
  };
}
