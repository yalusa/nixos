# Python settings — single-sourced from the market-dashboard flake.
# pythonEnv and the app itself both come from flake.nix's own package
# outputs, so the dependency list only ever needs to be edited in one
# place (flake.nix's `pythonEnv` definition).
{ pkgs, ... }:

let
  flake = builtins.getFlake "path:/mnt/data/GDrive/AI/market";
in
{
  environment.systemPackages = [
    flake.packages.${pkgs.system}.pythonEnv
    flake.packages.${pkgs.system}.default
  ];
}
