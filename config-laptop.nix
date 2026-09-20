# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-laptop.nix
      # Flatpak custom setups
      ./flatpak.nix
      # AppImages
      ./appimage.nix
      # security - root passwords
       ./security.nix
      # Python settings
       ./python.nix
      # Packages
       ./packages.nix
    ];

  # Force systemd to kill hanging user sessions faster on shutdown (e.g., 10 seconds)
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "45s";
  };

  # Bash Prompt
  programs.bash.promptInit = ''
    if [ "$EUID" -eq 0 ]; then
      # Red for Root
      PS1="\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]# "
    else
      # Green for User
      PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
    fi
  '';

  # Safely append custom Flatpak paths without destroying standard NixOS paths
  environment.extraInit = ''
    export XDG_DATA_DIRS="/mnt/btrfs/flatpak/exports/share:$XDG_DATA_DIRS"
  '';

  # Bind mount the external Flatpak directory straight to the expected system path
  fileSystems."/var/lib/flatpak" = {
    device = "/mnt/btrfs/flatpak";
    fsType = "none";
    options = [ "bind" ];
  };

  # Symlink binaries to standard paths (e.g., /bin/bash)
  environment.pathsToLink = [ "/bin" "/usr/bin" ];

  # Force /bin/sh to point to bash
  environment.binsh = "${pkgs.bash}/bin/bash";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  # Filesystems
  boot.supportedFilesystems = [ "ntfs" "nfs" ];

  # Networking
  networking.hostName = "asus-nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # mlocate service handles package injection natively
  services.locate.enable = true;
  services.locate.package = pkgs.mlocate;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_ZA.UTF-8";

  # Explicitly enable system-wide Polkit support for background daemons like fwupd
  security.polkit.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Budgie Desktop environment & legacy LightDM configuration paths
  services.xserver.displayManager.lightdm.enable = true;
  services.desktopManager.budgie.enable = true;

  # Enable the COSMIC desktop environment and its greeter/session files
  services.desktopManager.cosmic.enable = true;

# Ensure GTK/GDK pixbuf loaders are tracked system-wide
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";  # Primary: za, Secondary: us
    xkb.variant = ",intl";  # Enable US International variant
    xkb.options = "compose:ralt";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users.jongi = {
    isNormalUser = true;
    uid = 1000;
    description = "jongi";
    group = "jongi";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # Explicitly declare the custom primary group if it isn't automatically managed
  users.groups.jongi = {
    gid = 1000;
  };

  # Enable automatic login for the user using standard modern parameters.
  services.displayManager.autoLogin = {
    enable = true;
    user = "jongi";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "no";
    };
  };

  system.stateVersion = "24.11"; 

# Global Desktop Portal Engine for Budgie on labwc
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      # This forces ALL desktop session types to route screenshots through the wlr backend
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      };
      budgie = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      };
    };
  };

}
