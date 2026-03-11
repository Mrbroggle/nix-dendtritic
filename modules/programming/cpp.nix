{
  flake.nixosModules.cpp = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      gcc
      meson
      cmake
      gnumake
    ];
  };
}
