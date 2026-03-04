{
  flake.nixosModules.base = {pkgs, ...}: {
    programs.git = {
      enable = true;
      config = {
        user = {
          name = "Grady B";
          email = "broggl@broggl.farm";
        };
        init.defaultBranch = "master";

        credential.helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
        credential.credentialStore = "secretservice";
        push = {autoSetupRemote = true;};
      };
    };
  };
}
