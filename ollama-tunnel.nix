{ config, pkgs, ... }:

{
  systemd.user.services.ollama-tunnel = {
    description = "SSH tunnel to Ollama on the desktop";
    wantedBy = [ "default.target" ];
    after = [ "network-online.target" ];
    # User services get a minimal PATH on NixOS, so tell autossh where ssh is
    environment.AUTOSSH_PATH = "${pkgs.openssh}/bin/ssh";
    serviceConfig = {
      ExecStart = "${pkgs.autossh}/bin/autossh -M 0 -N -o BatchMode=yes -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -L 11434:127.0.0.1:11434 desktop";
      Restart = "always";
      RestartSec = 10;
    };
  };
}
