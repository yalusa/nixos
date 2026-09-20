# Python settings — single-sourced from market_dashboard.nix.
# pythonEnv and the app itself both come from that file, so the
# dependency list only ever needs to be edited in one place
# (market_dashboard.nix's `pythonEnv` definition).
{ pkgs, ... }:

let
  marketDashboard = pkgs.callPackage ./market_dashboard.nix { };
in
{
  environment.systemPackages = [
    marketDashboard.pythonEnv
    marketDashboard
  ];
}
