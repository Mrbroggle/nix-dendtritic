{inputs, ...}: {
  flake.nixosModules.secrets = {
    config,
    username,
    ...
  }: {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    sops = {
      defaultSopsFile = ./secrets.yaml;
      age = {
        sshKeyPaths = ["/home/${username}/.ssh/laptopPcKey"];
        keyFile = "/home/${username}/.config/sops/age/keys.txt";
        generateKey = true;
      };
      secrets.password = {
        neededForUsers = true;
      };
    };
  };
}
