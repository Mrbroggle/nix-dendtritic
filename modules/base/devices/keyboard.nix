{
  flake.nixosModules.keyboard = {lib, ...}: {
    boot.kernelModules = ["uinput"];

    hardware.uinput.enable = true;

    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

    users.groups.uinput = {};

    systemd.services.kanata-internalKeyboard = {
      serviceConfig = {
        # 1. Overriding the restrictive defaults of the Kanata module
        # Root needs 'PrivateDevices=false' to see the real /dev/uinput
        PrivateDevices = lib.mkForce false;
        ProtectDevices = lib.mkForce false;
        ProtectSystem = lib.mkForce "no";
        ProtectHome = lib.mkForce "no";

        # 2. Explicitly granting device access to the cgroup
        DeviceAllow = [
          "/dev/uinput rw"
          "/dev/input/event* rw"
          "/dev/input/by-path/* rw"
        ];

        SupplementaryGroups = [
          "input"
          "uinput"
        ];

        # 3. Ensure it runs as root and has hardware capabilities
        User = "root";
        CapabilityBoundingSet = [
          "~"
          "CAP_SYS_ADMIN"
        ];
      };
    };

    services.kanata = {
      enable = true;
      keyboards = {
        internalKeyboard = {
          port = 6666;
          # devices = [
          #   "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          #];
          extraDefCfg = "process-unmapped-keys yes concurrent-tap-hold yes";
          config = ''
            (defsrc
              esc   f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11   f12  del
              grv    1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab    q    w    e    r    t    y    u    i    o    p    [    ]    \
              caps   a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft   z    x    c    v    b    n    m    ,    .    /      rsft
              lctl lmet  lalt         spc           ralt rctl
            )

            (deflayer QWERTY

              esc   f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11   f12  del
              grv    1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab    q    w    e    r    t    y    u    i    o    p    [    ]    \
              esc a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft   z    x    c    v    b    n    m    ,    .    /      rsft
              lctl lmet  lalt         spc           ralt rctl
            )
          '';
        };
      };
    };
  };
}
