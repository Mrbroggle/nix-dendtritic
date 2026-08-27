{
  inputs,
  config,
  ...
}: {
  flake.nixosModules.base = _: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";

      sharedModules = [
        inputs.lazyvim.homeManagerModules.default
      ];
    };
  };

  flake.homeModules.base = {pkgs, ...}: {
    home.stateVersion = "25.05";

    imports = [
      config.flake.homeModules.shell
    ];
  };
}
