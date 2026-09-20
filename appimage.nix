  # AppImages
  {
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  }

#  {
#  programs.appimage.package = pkgs.appimage-run.override {
#    extraPkgs = pkgs: [
#      # missing libraries here, e.g.: `pkgs.libepoxy`
#      ];
#    }
#  }
