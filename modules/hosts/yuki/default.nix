{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.yuki = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostYuki
    ];
  };
  flake.nixosModules.hostYuki = {pkgs, ...}: {
    imports = [
      self.nixosModules.base

      inputs.nixos-wsl.nixosModules.default

      {
        stdenv.hostPlatform.system.stateVersion = "25.05";
        wsl.enable = true;
      }
    ];

    stdenv.hostPlatform.system.stateVersion = "25.05";
  };
}
