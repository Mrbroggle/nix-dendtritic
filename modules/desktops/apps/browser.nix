{
  flake.nixosModules.browsers = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      (vivaldi.override {
        commandLineArgs = "--password-store=kwallet6";
      })
    ];
  };
}
