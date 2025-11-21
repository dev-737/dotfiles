{ config, pkgs, ... }:

let
  system = "x86_64-linux";
  atlas-standard = pkgs.stdenv.mkDerivation rec {
    pname = "atlas-standard";
    version = "v0.38.1-d98fb08-canary";

    src = pkgs.fetchurl {
      url = "https://release.ariga.io/atlas/atlas-linux-amd64-${version}";
      sha256 = "sha256-1qD5wH2S38sFIUZDa+NgHDQXPaLC2mx+KIbb+C9+du8=";
    };

    dontUnpack = true;

    # autoPatchelfHook fixes the binary to run on NixOS
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/atlas
      chmod +x $out/bin/atlas
    '';
  };
in
{
  home.username = "devoid";
  home.homeDirectory = "/home/devoid";
  home.stateVersion = "25.05";

  programs.bash = {
    enable = true;
    shellAliases = {
	    n = "nvim";
    };
    profileExtra = ''
      # if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      #   exec hyprland;
      # fi
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec niri-session -l;
      fi
    '';
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  programs.nushell = { 
      enable = true;
      configFile.source = ./config/nushell/config.nu;

      extraConfig = ''
       let carapace_completer = {|spans|
         carapace $spans.0 nushell ...$spans | from json
       }

       $env.config = {
        show_banner: false,

        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
          external: {
            enable: true 
            max_results: 100 
            completer: $carapace_completer
          }
        }
       } 

       $env.PATH = ($env.PATH | 
          split row (char esep) |
          prepend /home/myuser/.apps |
          append /usr/bin/env
       )
       '';
    shellAliases = {
      n = "nvim";
      cls = "clear";
    };
  };  

# if (
#      ( ($env.WAYLAND_DISPLAY? | default "") == "" )
#      and
#      ($env.XDG_VTNR? | default "") == "1"
#     ) {
#       exec niri-session
#     }
  
  programs.carapace = {
     enable = true;
     enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
         add_newline = true;
         character = { 
         success_symbol = "[➜](bold green)";
         error_symbol = "[➜](bold red)";
       };
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=11, Noto Color Emoji";
        shell = "${pkgs.nushell}/bin/nu";
      };
      
      colors = {
        background = "282828";
        foreground = "ebdbb2";

        ## Normal/Regular Colors (0-7)
        regular0 = "282828";  # bg
        regular1 = "cc241d";  # red
        regular2 = "98971a";  # green
        regular3 = "d79921";  # yellow
        regular4 = "458588";  # blue
        regular5 = "b16286";  # purple
        regular6 = "689d6a";  # aqua
        regular7 = "a89984";  # gray

        ## Bright/Bold Colors (8-15)
        bright0 = "928374";   # gray
        bright1 = "fb4934";   # red
        bright2 = "b8bb26";   # green
        bright3 = "fabd2f";   # yellow
        bright4 = "83a598";   # blue
        bright5 = "d3869b";   # purple
        bright6 = "8ec07c";   # aqua
        bright7 = "ebdbb2";   # fg

        ## Selection colors
        selection-background = "504945";
        selection-foreground = "ebdbb2";

        ## Extra Gruvbox colors (Orange)
        ## Numeric keys must be quoted in Nix
        "16" = "d65d0e";
        "17" = "fe8019";

        ## Misc
        urls = "83a598";
      };
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.foot}/bin/foot";
        layer = "overlay";
      };
      colors = {
        background = "0d1510ff";
        text = "dce5dcff";
        selection = "3c4a40ff";
        selection-text="bbcabdff";
        border="3c4a40dd";
        match="ffb4aaff";
        selection-match="ffb4aaff";
    };
    };
  };


  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    satty
    ripgrep
    nil
    nixpkgs-fmt
    gcc
    nitch
    nemo
    vesktop
    brightnessctl
    gh
    neovim
    xwayland-satellite
    uv
    p7zip
    unrar
    atlas-standard
  ];


  # home.file.".config/waybar".source = ./config/waybar;
  # home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/niri".source = ./config/niri;
  home.file.".config/electron-flags.conf".source = ./config/electron-flags.conf;
  home.file.".config/code-flags.conf".source = ./config/code-flags.conf;
}
