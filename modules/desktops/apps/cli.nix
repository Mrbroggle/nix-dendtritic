{
  flake.nixosModules.appSuite = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      sops
      age
      expect
      mosh
      pre-commit
      direnv
      nix-output-monitor
      wget
      ffmpeg
      unixtools.net-tools
      kdePackages.ffmpegthumbs
      cpio
      fastfetch
      unzip
      gzip
      ueberzugpp
      jq
      chafa
      libnotify
      nurl
      ueberzugpp
    ];
    services = {
      fwupd.enable = true;
    };
  };
}
