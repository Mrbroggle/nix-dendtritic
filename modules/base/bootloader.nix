{
  inputs,
  config,
  ...
}: {
  # These are the "Top Level" inputs from your flake
  flake.nixosModules.secureBootLoader = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.lanzaboote.nixosModules.lanzaboote
      config.flake.nixosModules.bootLoader
    ];
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    environment.systemPackages = [
      pkgs.sbctl
    ];
  };

  flake.nixosModules.bootLoader = _: {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
  };
}
