{ config, pkgs, ... }:
{
  security.sudo = {
    enable = true;
    # Require root password instead of user password for sudo/wheel groups
    extraConfig = ''
      Defaults	       rootpw
      Defaults:%sudo   rootpw    # Enforce root password for 'sudo' group
      Defaults:%wheel  rootpw    # Enforce root password for 'wheel' group
      Defaults timestamp_timeout=0  # Require re-authentication every time
    '';
  };

  # Enable PolKit security
  security.polkit.enable = true;
  security.polkit.adminIdentities = [ "unix-user:root" ];
  security.polkit.extraConfig = ''
  // Always require root password for administrative actions, even for wheel group members.
  polkit.addRule(function(action, subject) {
      // Check if the user is in the 'wheel' group.
      if (subject.isInGroup("wheel")) {
          // Set the required authorization to "auth_admin_keep_session", which will
          // explicitly prompt for the root password for the duration of the session.
          return polkit.Result.AUTH_ADMIN_KEEP_SESSION;
      }
  });
'';
}
