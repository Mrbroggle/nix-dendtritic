{
  flake.nixosModules.browsers = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      vivaldi
    ];
  };
}
