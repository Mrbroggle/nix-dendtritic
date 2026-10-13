{
  flake.nixosModules.gamedev = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      godot
    ];
  };
}
