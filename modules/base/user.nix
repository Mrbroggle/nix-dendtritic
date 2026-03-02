{
  flake.nixosModules.base = {
    config,
    pkgs,
    username,
    ...
  }: {
    programs.fish.enable = true;
    users.users.${username} = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.password.path;
      extraGroups = [
        "networkmanager"
        "wheel"
        "dialout"
        "libvirt"
        "kvm"
        "wireshark"
        "uinput"
        "input"
      ];
      shell = pkgs.fish;
    };
  };
  flake.homeModules.user = {username, ...}: {
    home = {
      inherit username;
      stateVersion = "25.05";
    };
  };
}
