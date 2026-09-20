{ config, pkgs, ... }:
{
  security.sudo = {
    enable = true;
    # Require root password instead of user password for sudo/wheel groups
    extraConfig = ''
      Defaults:%sudo   rootpw    # Enforce root password for 'sudo' group
      Defaults:%wheel  rootpw    # Enforce root password for 'wheel' group
      Defaults timestamp_timeout=0  # Require re-authentication every time
    '';
  };
}
