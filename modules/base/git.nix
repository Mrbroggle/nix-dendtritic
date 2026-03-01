{
  flake.nixosModules.base = {
    programs.git = {
      enable = true;
      config = {
        user = {
          name = "Grady B";
          email = "broggl@broggl.farm";
        };
        init.defaultBranch = "master";

        push = {autoSetupRemote = true;};
      };
    };
  };
}
