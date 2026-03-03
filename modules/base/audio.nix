{
  flake.nixosModules.audio = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      pavucontrol
      qpwgraph
    ];
  };
}
