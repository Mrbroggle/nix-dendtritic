{
  flake.nixosModules.chat = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      element-desktop
      whatsie
    ];
  };
}
