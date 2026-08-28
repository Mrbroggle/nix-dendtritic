{
  flake.nixosModules.cpp = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      gcc
      meson
      cmake
      gnumake
      gdbgui
      pkg-config
      ncurses
    ];
    environment.extraOutputsToInstall = ["dev"];
    services.rpcbind.enable = true;
  };
}
