{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    autossh
    thunar
    pipx
    nodejs
    p7zip
    polkit_gnome
    lxqt.lxqt-policykit
    kdePackages.polkit-kde-agent-1
    librsvg
    gdk-pixbuf
    shared-mime-info
    libnotify
    grim
    slurp
    crystal-dock
    flet-client-flutter
    nix-index
    kdePackages.partitionmanager
    android-tools
    bat
    htop
    naps2
    telegram-desktop
    bash
    wget
    gparted
    mlocate
    thunderbird
    insync
    git
    nix-output-monitor
    inxi
    pciutils
    e2fsprogs
    kdePackages.dolphin
    lxterminal
    kdePackages.falkon
    kdePackages.skanpage
    ncdu
    gh
    github-release
    github-desktop
    ffmpeg
    mplayer
    efibootmgr
    clementine
    pavucontrol
    discord
    mlocate
    samba
    wirelesstools
    firefox
    gtk3
    gtk4
    kdePackages.breeze-icons  # KDE's Breeze icons
    hicolor-icon-theme        # Fallback icon theme
    adwaita-icon-theme        # GNOME's default icons
  ];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

}
