{ config, pkgs, ... }:

{

  # Add android-tools to system packages
  environment.systemPackages = with pkgs; [
    android-tools
  ];
}
