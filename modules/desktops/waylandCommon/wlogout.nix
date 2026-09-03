{
  flake.homeModules.wlogout = {
    pkgs,
    lib,
    ...
  }: {
    programs.wlogout = {
      enable = true;
      layout = [
        {
          "label" = "lock";
          "action" = "${lib.getExe pkgs.hyprlock}";
          "text" = "Lock";
          "keybind" = "l";
        }

        {
          "label" = "logout";
          "action" = "${lib.getExe pkgs.hyprshutdown}";
          "text" = "Logout";
          "keybind" = "e";
        }
        {
          "label" = "hibernate";
          "action" = "systemctl hibernate";
          "text" = "Hibernate";
          "keybind" = "h";
        }
        {
          "label" = "suspend";
          "action" = "systemctl suspend";
          "text" = "Suspend";
          "keybind" = "u";
        }
        {
          "label" = "shutdown";
          "action" = "systemctl poweroff";
          "text" = "Shutdown";
          "keybind" = "s";
        }

        {
          "label" = "reboot";
          "action" = "systemctl reboot";
          "text" = "Reboot";
          "keybind" = "r";
        }
      ];
    };
  };
}
