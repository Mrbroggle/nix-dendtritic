{
  flake.nixosModules.winboat = {
    config,
    username,
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = [pkgs.winboat];
    virtualisation.docker.enable = true;
    users.users.${username}.extraGroups = ["docker"];
  };
}
