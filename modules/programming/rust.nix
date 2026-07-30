{
  flake.nixosModules.rust = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      rustc
      cargo
    ];
    environment.extraOutputsToInstall = ["dev"];
  };
}
