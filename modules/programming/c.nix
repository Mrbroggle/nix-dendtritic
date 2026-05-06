{
  flake.nixosModules.c = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      gcc
      ncurses
    ];
  };
}
