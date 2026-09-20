{ pkgs, ... }:

{
  # 1. Enable Flatpak service frameworks natively
  services.flatpak.enable = true;

  # 2. Force NixOS profiles to actively index the shared location
  environment.profiles = [
    "/mnt/btrfs/flatpak/exports"
  ];

  # 3. Declaratively generate a modern systemd service ensuring flathub is available
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # 4. Wayland Budgie Application Override Engine
  # Drops the KDE conflict hack, keeps execution clean for the labwc compositor,
  # and writes clean icons that Budgie's indexed environment can naturally resolve.
  system.activationScripts.flatpakLauncherFix = {
    text = ''
      TARGET_DIR="/home/jongi/.local/share/applications"
      mkdir -p "$TARGET_DIR"

      for src in /mnt/btrfs/flatpak/exports/share/applications/*.desktop; do
        [ -e "$src" ] || continue
        filename=$(basename "$src")
        appid=''${filename%.desktop}

        # Extract metadata keys cleanly
        name=$(grep -m 1 "^Name=" "$src" | cut -d'=' -f2)
        icon_name=$(grep -m 1 "^Icon=" "$src" | cut -d'=' -f2)
        categories=$(grep -m 1 "^Categories=" "$src" | cut -d'=' -f2)

        # Precise window class maps tailored to match Wayland app identities
        case "$appid" in
          "com.discordapp.Discord")           wmclass="discord" ;;
          "com.valvesoftware.Steam")          wmclass="steam" ;;
          "org.jellyfin.JellyfinDesktop")     wmclass="jellyfinmediaplayer" ;;
          "com.microsoft.Edge")               wmclass="microsoft-edge" ;;
          "org.onlyoffice.desktopeditors")    wmclass="org.onlyoffice.desktopeditors" ;;
          "org.flameshot.Flameshot")          wmclass="flameshot" ;;
          *)
            upstream_wmclass=$(grep -m 1 "^StartupWMClass=" "$src" | cut -d'=' -f2)
            wmclass="''${upstream_wmclass:-$appid}"
            ;;
        esac

        # Generate custom launchers utilizing native system environment bindings
        echo "[Desktop Entry]
        Name=$name
        Exec=${pkgs.flatpak}/bin/flatpak run $appid %U
        Terminal=false
        Type=Application
        Icon=$icon_name
        StartupWMClass=$wmclass
        Categories=$categories" > "$TARGET_DIR/$filename"
      done

      chown -R jongi:jongi "$TARGET_DIR"
    '';
  };

  # 5. Global tool alignment for Wayland clipboard runtimes
  environment.systemPackages = with pkgs; [
    wl-clipboard 
    xclip        
  ];

# 6. utomate the Flatpak User-Space Sync on every desktop login
  systemd.user.services.flatpak-user-sync = {
    description = "Synchronize shared Flatpak user profile symlinks and overrides";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/mnt/btrfs/flatpak/flatpak-update";
      RemainAfterExit = true;
    };
  };
}
