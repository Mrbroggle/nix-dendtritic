{inputs, ...}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
    formatter = pkgs.alejandra;
  };

  flake.nixosModules.base = _: {
    imports = [
      inputs.determinate.nixosModules.default
    ];
    nix = {
      optimise.automatic = true;
      optimise.dates = ["07:45"];
      settings = {
        warn-dirty = false;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        eval-cores = 8;

        substituters = [
          "https://install.determinate.systems"
          "https://cache.flakehub.com"
          "https://cache.determinate.systems"
        ];

        trusted-public-keys = [
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
          "cache.determinate.systems-1:99vU8v06t/48HVsY/uB8GIsV3VskDkHhLFeh9h5vH48="
        ];
      };
    };

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 5";
      };
      flake = "/home/gradyb/etc/nixos/";
    };
    #  system.copySystemConfiguration = true;

    system.stateVersion = "25.05";
  };
}
