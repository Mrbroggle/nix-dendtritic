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
        credential.credentialStore = "file"; # Tells GCM to use a file backend
        push = {autoSetupRemote = true;};
      };
    };
  };
  flake.homeModules.base = {osConfig, ...}: {
    home.sessionVariables = {
      GCM_CREDENTIAL_STORE_FILE = osConfig.sops.templates."gcm-gitea".path;
    };
  };
}
