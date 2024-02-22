{ pkgs, ... }: {
  programs.home-manager.enable = true;
  programs.kitty = {
    enable = true;
    font = {
      name = "SauceCodePro Nerd Font Mono";
      size = 11.0;
    };
    theme = "Molokai";
  };
  home.stateVersion = "23.11";
}
