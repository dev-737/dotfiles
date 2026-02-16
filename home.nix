{ config, pkgs, zen-browser, ... }:

let
  system = "x86_64-linux";
  atlas-standard = pkgs.stdenv.mkDerivation rec {
    pname = "atlas-standard";
    version = "v1.0.0";

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
  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
    shellAliases = {
	    n = "nvim";
	    firefox = "firefox-nightly";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec niri-session -l;
      fi
    '';
  };

  programs.nushell = { 
      enable = true;
      # configFile.source = ./config/nushell/config.nu;

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
        hooks: {
          pre_prompt: [{ ||
            if (which direnv | is-empty) {
              return
            }

            direnv export json | from json | default {} | load-env
            if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
              $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
            }
          }]
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
	    firefox = "firefox-nightly";
    };
  };  

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
      
      # colors = {
      #   background = "282828";
      #   foreground = "ebdbb2";
      #
      #   ## Normal/Regular Colors (0-7)
      #   regular0 = "282828";  # bg
      #   regular1 = "cc241d";  # red
      #   regular2 = "98971a";  # green
      #   regular3 = "d79921";  # yellow
      #   regular4 = "458588";  # blue
      #   regular5 = "b16286";  # purple
      #   regular6 = "689d6a";  # aqua
      #   regular7 = "a89984";  # gray
      #
      #   ## Bright/Bold Colors (8-15)
      #   bright0 = "928374";   # gray
      #   bright1 = "fb4934";   # red
      #   bright2 = "b8bb26";   # green
      #   bright3 = "fabd2f";   # yellow
      #   bright4 = "83a598";   # blue
      #   bright5 = "d3869b";   # purple
      #   bright6 = "8ec07c";   # aqua
      #   bright7 = "ebdbb2";   # fg
      #
      #   ## Selection colors
      #   selection-background = "504945";
      #   selection-foreground = "ebdbb2";
      #
      #   ## Extra Gruvbox colors (Orange)
      #   ## Numeric keys must be quoted in Nix
      #   "16" = "d65d0e";
      #   "17" = "fe8019";
      #
      #   ## Misc
      #   urls = "83a598";
      # };
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

  programs.direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      niri = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
  };


  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;

    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.vscode = {
    enable = true;

    package = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
        src = builtins.fetchTarball {
          url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
          sha256 = "0blw5q9gd0v5k9m8zh1144s5srw626zihscrkh787wbadcw4pz3a";
        };
        version = "latest";
        
        # Keep these dependencies for the base package
        buildInputs = oldAttrs.buildInputs ++ [
          pkgs.krb5
          pkgs.libsoup_3
          pkgs.webkitgtk_4_1
        ];
      });
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
    brightnessctl
    xwayland-satellite
    p7zip
    unrar
    unzip
    pgcli
    obsidian
    vim
    aseprite
    steam-run
    dotnet-sdk_8
    gpu-screen-recorder
    nautilus
    gnupg
    pinentry-qt
    gh
    termius
    neovim
    qbittorrent
    steam-run
    dotnet-sdk_8
    steam
    nitch
    cmake
    jellyfin-desktop
    (zen-browser.packages."${system}".default.override {
      extraPolicies = {
        DisableTelemetry = true;
      };
    })
  ];

  home.file.".config/niri".source = ./config/niri;
  home.file.".config/electron-flags.conf".source = ./config/electron-flags.conf;
  home.file.".config/code-flags.conf".source = ./config/code-flags.conf;
}
