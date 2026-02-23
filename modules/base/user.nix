{
  flake.nixosModules.base = {pkgs, ...}: {
    programs.fish.enable = true;
    users.users.gradyb = {
      isNormalUser = true;
      description = "grady brown";
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
  flake.homeModules.user = _: {
    home = {
      username = "gradyb";
      stateVersion = "25.05";
    };
  };
}
