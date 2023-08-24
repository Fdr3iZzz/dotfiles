# shared home-manager configuration
{
  config,
  pkgs,
  user,
  ...
}: {
  home.packages = with pkgs; [
    htop
  ];
}
