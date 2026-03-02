{inputs, ...}: {
  flake.nixosModules.secrets = {config, ...}: {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    sops = {
      defaultSopsFile = ./secrets.yaml;
      age = {
        sshKeyPaths = ["/home/gradyb/.ssh/laptopPcKey"];
        keyFile = "/home/gradyb/.config/sops/age/keys.txt";
        generateKey = true;
      };
      secrets.password = {
        neededForUsers = true;
      };
      templates."gcm-gitea" = {
        content = ''
          protocol=https
          host=gitea.yourdomain.com
          username=${config.sops.gitea.usermame}
          password=${config.sops.gitea.password}
        '';
        owner = "gradyb";
      };
    };
  };
}
