{ config, pkgs, ... }: {

  users.users = {
    john = {
      home = "/Users/john";
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ 
      pkgs.ack
      pkgs.brotli
      pkgs.cloudflared
      pkgs.ffmpeg
      pkgs.fzf
      pkgs.git
      pkgs.htop
      pkgs.jq
      pkgs.kitty-img
      pkgs.kitty-themes
      pkgs.neovim
      pkgs.ngrok
      pkgs.readline
      pkgs.ripgrep
      pkgs.silver-searcher
      pkgs.tldr
      pkgs.tree
      pkgs.wget
      pkgs.zoxide
    ];

  environment.variables = {
    EDITOR = "nvim";
  };

  environment.shellAliases = {
    ls = "ls -G";
    vim = "nvim";
    vi = "vim";
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      # Use backtick as the prefix
      # Do it just like this or you will not 
      # be able to use type backtick literally
      unbind C-b
      unbind C-d
      set-option -g prefix `
      bind ` send-prefix
      bind-key L last-window

      set -g base-index 1

      set-option -g default-command "zsh"
      set -g default-terminal "screen-256color"

      # Make mouse useful in copy mode
      setw -g mouse on

      # # Scroll History
      set -g history-limit 30000
      #
      # # Set ability to capture on start and restore on exit window data when running an application
      setw -g alternate-screen on
      #
      # Basically allows for faster key repetition
      set -s escape-time 0

      # Set status bar
      set -g status-justify left
      # set -g status-bg black
      # set -g status-fg white
      set-option -g status-interval 5
      set -g status-right-length 150
      set -g status-left ""
      set -g status-right "#[fg=green] %m-%d-%Y %H:%M"
      set-option -g status-position top

      # Rather than constraining window size to the maximum size of any client 
      # connected to the *session*, constrain window size to the maximum size of any 
      # client connected to *that window*. Much more reasonable.
      setw -g aggressive-resize on

      # Allows us to use '<prefix>-a' <command> to send commands to a TMUX session inside 
      # another TMUX session
      bind-key a send-prefix

      # Highlight active window
      set-window-option -g window-status-current-style bg=red

      # Turn on vi bindings in copy mode
      set-option -g status-keys vi
      set-window-option -g mode-keys vi

      # Setup 'v' to begin selection as in Vim
      # bind-key -t vi-copy v begin-selection
      # bind-key -t vi-copy y copy-pipe "xclip -sel clip -i"
      #

       # move between panes
      bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-h) || tmux select-pane -L"
      bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-j) || tmux select-pane -D"
      bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-k) || tmux select-pane -U"
      bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-l) || tmux select-pane -R"

      bind H swap-window -t -1
      bind L swap-window -t +1
      bind r source-file ~/.tmux.conf
      bind S new
      bind s choose-session
      bind M-k send-keys C-l \; run-shell "sleep .3s" \; clear-history

      bind v split-window -h -c '#{pane_current_path}'
      bind h split-window -v -c '#{pane_current_path}'

      # Copy to OSX clipboard
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"

      # List of plugins
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-sensible'

      set -g @plugin 'dracula/tmux'

      set -g @dracula-plugins "battery ram-usage"
      set -g @dracula-show-powerline true
      set -g @dracula-show-left-icon session
      set -g @dracula-show-flags true
      set -g @dracula-show-timezone false

      bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt
      set -g detach-on-destroy off  # don't exit from tmux when closing a session

      bind-key "t" run-shell "sesh connect $(
        sesh list -tz | fzf-tmux -p 55%,60% \
          --no-sort --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^x zoxide ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)'
      )"

      # Other examples:
      # set -g @plugin 'github_username/plugin_name'
      # set -g @plugin 'github_username/plugin_name#branch'
      # set -g @plugin 'git@github.com:user/plugin'
      # set -g @plugin 'git@bitbucket.com:user/plugin'

      # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nixpkgs.config = { allowUnfree = true; };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    enableFzfHistory = true;
    promptInit = "";
    interactiveShellInit = ''
      HISTSIZE=10000
      SAVEHIST=10000
      if [ -f "$HOME/dotfiles/zsh/zgen.zsh" ]; then
        source "$HOME/dotfiles/zsh/zgen.zsh" # ~25ms
      fi

      if [ -n "$(command -v zgen)" ]; then
        if ! zgen saved; then # TODO: auto invalidate on build
          echo "========== Creating a zgen save =========="

          # plugins
          zgen oh-my-zsh
          zgen oh-my-zsh plugins/nvm
          zgen load mafredri/zsh-async "" main
          zgen load sindresorhus/pure "" main

          #zgen oh-my-zsh plugins/tmux
          # save all to init script
          zgen save
        fi
      fi
      function t () {
        sesh connect $(sesh list -tz | fzf)
      }
      eval "$(/opt/homebrew/bin/brew shellenv)"
      alias vim="nvim"
      alias vi="vim"
      alias ls="ls -G"
      eval "$(zoxide init zsh)"
    '';
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      # cleanup = "zap";
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask-versions"
      "shopify/shopify"
    ];

    brews = [
      # "aria2"  # download tool
      "shopify-cli"
      "joshmedeski/sesh/sesh"
    ];

    casks = [
      "google-chrome"
      "firefox"
      "kitty"
    ];

  };
}
