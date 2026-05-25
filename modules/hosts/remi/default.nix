{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.remi = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostRemi
    ];
  };
  flake.nixosModules.hostRemi = {pkgs, ...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.secureBootLoader
      self.nixosModules.tailscale
      self.nixosModules.networking
    ];

    stdenv.hostPlatform.system.stateVersion = "25.05";
  };
}
