# Hyprland Installation and Configuration on Arch Linux

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [System Preparation](#system-preparation)
4. [Hyprland Installation](#hyprland-installation)
5. [Essential Applications](#essential-applications)
6. [Configuration Setup](#configuration-setup)
7. [Post-Installation](#post-installation)
8. [Usage Guide](#usage-guide)
9. [Customization](#customization)
10. [Additional Resources](#additional-resources)

---

## Introduction

This guide covers the installation and configuration of [Hyprland](https://hyprland.org/) on a fresh Arch Linux system, using the dots-files repository as the configuration source.

### Stack

| Tool                                                           | Role                              |
| -------------------------------------------------------------- | --------------------------------- |
| [Hyprland](https://hyprland.org)                               | Wayland compositor                |
| [Waybar](https://github.com/Alexays/Waybar)                    | Status bar                        |
| [Hyprlock](https://github.com/hyprwm/hyprlock)                 | Screen locker                     |
| [Hyprpaper](https://github.com/hyprwm/hyprpaper)               | Wallpaper daemon                  |
| [Hypridle](https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/) | Idle management                   |
| [Dunst](https://dunst-project.org)                             | Notification daemon               |
| [SwayNC](https://github.com/ErikReider/SwayNotificationCenter) | Notification center (alternative) |
| [Rofi](https://github.com/davatorium/rofi)                     | Application launcher              |
| [Ghostty](https://ghostty.org)                                 | Primary terminal                  |
| [Kitty](https://sw.kovidgoyal.net/kitty/)                      | Secondary terminal                |
| [Zellij](https://zellij.dev)                                   | Terminal multiplexer              |
| [Neovim](https://neovim.io)                                    | Editor (LazyVim)                  |
| [VS Code](https://code.visualstudio.com)                       | GUI editor                        |
| [Zsh + Oh My Zsh](https://ohmyz.sh)                            | Shell                             |
| [Brave](https://brave.com)                                     | Browser                           |
| [Thunar](https://wiki.archlinux.org/title/Thunar)              | GUI file manager                  |
| [Dolphin](https://apps.kde.org/dolphin/)                       | GUI file manager (secondary)      |
| [Yazi](https://yazi-rs.github.io)                              | Terminal file manager             |
| [mpv](https://mpv.io)                                          | Video/audio player                |
| [wlogout](https://github.com/ArtsyMacaw/wlogout)               | Logout / power menu               |
| [SDDM](https://github.com/sddm/sddm)                           | Display manager                   |

All configurations are in the [dots-files](https://github.com/SouleymaneSy7/dots-files) repository, themed with **Catppuccin Macchiato** and **Rec Mono** fonts.

---

## Prerequisites

- Fresh Arch Linux installation (base system + networking)
- Internet connection
- Non-root user with sudo privileges
- Basic terminal knowledge

---

## System Preparation

### Update the System

```bash
sudo pacman -Syu
```

### Base Development Tools

```bash
sudo pacman -S base-devel git curl wget
```

Configure Git before cloning anything:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
git config --global core.longpaths true
```

### AUR Helper (yay)

yay is required for several packages in this setup (Ghostty, Brave, wlogout, Yazi extras, etc.):

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
rm -rf yay
```

### Clone dots-files

```bash
git clone https://github.com/SouleymaneSy7/dots-files.git ~/dots-files
```

---

## Hyprland Installation

Install Hyprland and its full ecosystem in one pass:

```bash
# Compositor and core tools
sudo pacman -S hyprland hyprlock hyprpaper hypridle

# Wayland portals and Qt support
sudo pacman -S xdg-desktop-portal-hyprland xdg-utils xdg-user-dirs \
  qt5-wayland qt6-wayland

# Authentication agent (GUI sudo prompts)
sudo pacman -S polkit-kde-agent

# Brightness and input
sudo pacman -S brightnessctl

# Clipboard
sudo pacman -S wl-clipboard cliphist
```

#### Pyprland (scratchpad terminal)

```bash
yay -S pyprland
```

#### System Utilities

```bash
# Volume
sudo pacman -S pamixer pavucontrol

# Notifications
sudo pacman -S dunst libnotify

# Notification center (alternative to dunst)
yay -S swaync

# Screenshots
sudo pacman -S grim slurp hyprpicker
yay -S satty

# Logout menu
yay -S wlogout
```

#### Audio (PipeWire)

```bash
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

#### SDDM (Display Manager)

```bash
sudo pacman -S sddm qt6-svg qt6-declarative qt5-quickcontrols2
```

Install the Catppuccin Macchiato Blue theme. The script below will:

- Download and install the theme to `/usr/share/sddm/themes/`
- Write SDDM configuration (theme selection, Hyprland as default session, numlock)
- Ask whether to enable the SDDM service

```bash
~/dots-files/sddm/install-sddm-theme.sh
```

---

## Essential Applications

### Browser

```bash
yay -S brave-bin
```

### Terminals

```bash
# Ghostty — primary terminal
sudo pacman -S ghostty

# Kitty — secondary terminal
sudo pacman -S kitty

# Zellij — terminal multiplexer
sudo pacman -S zellij
```

### Shell (Zsh + Oh My Zsh)

#### Install Zsh

```bash
sudo pacman -S zsh zsh-completions
```

Change your default shell:

```bash
chsh -s $(which zsh)
```

#### Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

#### Install Plugins

```bash
# zsh-autocomplete
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# fast-syntax-highlighting (use this instead of zsh-syntax-highlighting)
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
```

#### Install Powerlevel10k

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
```

### Application Launcher

```bash
sudo pacman -S rofi-wayland
```

### Status Bar

```bash
sudo pacman -S waybar playerctl
```

### File Managers

```bash
# Thunar — primary GUI file manager
sudo pacman -S thunar thunar-volman thunar-archive-plugin \
  thunar-media-tags-plugin thunar-shares-plugin

# GVFS (mount, trash, remote filesystems, Samba)
sudo pacman -S gvfs gvfs-mtp gvfs-afc gvfs-smb

# Archive backends
sudo pacman -S file-roller xarchiver unrar

# Thumbnails and search
sudo pacman -S tumbler catfish

# Dolphin — secondary GUI file manager
sudo pacman -S dolphin

# Yazi — terminal file manager
sudo pacman -S yazi ffmpegthumbnailer poppler unarj
yay -S glow   # Markdown preview in Yazi
```

### Media Player

```bash
sudo pacman -S mpv vlc
```

### Development Runtimes

```bash
# Node.js (required for LSPs, Mason, and frontend tooling)
sudo pacman -S nodejs npm
```

### Text Editor (Neovim)

#### Install Neovim and Dependencies

```bash
sudo pacman -S neovim ripgrep fd tree-sitter-cli lazygit luarocks
```

#### Apply the dots-files Neovim Configuration

The setup starts from the official LazyVim starter (provides `init.lua` and the base structure), then extends it with custom plugins and configs from dots-files.

```bash
# Back up any existing configuration
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak

# Clone the LazyVim starter as the base
git clone --depth=1 https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# Extend with custom dotfiles (overrides lazy.lua, adds plugins and configs)
cp -r ~/dots-files/nvim/* ~/.config/nvim/
```

Start Neovim once to trigger plugin installation (takes 2–5 minutes):

```bash
nvim
```

LazyVim installs all plugins automatically. Wait for the checkmarks, then press `q` to close the Lazy panel.

### System Tools

```bash
sudo pacman -S btop fastfetch zoxide fzf bat eza fd ripgrep jq
yay -S atuin
```

### Network

```bash
# NetworkManager (WiFi, Ethernet)
sudo pacman -S networkmanager network-manager-applet nm-connection-editor
sudo systemctl enable --now NetworkManager
```

### Fonts

```bash
# Nerd Fonts (icons for Waybar, Neovim, Yazi, Fastfetch)
sudo pacman -S ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-firacode-nerd \
  ttf-ibmplex-mono-nerd ttf-iosevka-nerd ttf-jetbrains-mono-nerd ttf-meslo-nerd \
  ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono

# Unicode coverage
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji

fc-cache -fv
```

**Rec Mono** is the primary font for this project (Ghostty, Kitty, VS Code, Waybar, Rofi, Hyprlock). It is not in any Arch repository — download it manually:

- [recursive.design](https://www.recursive.design/) — official download
- [github.com/arrowtype/recursive/releases](https://github.com/arrowtype/recursive/releases) — direct releases

After downloading, copy the `.ttf` or `.otf` files to `~/.local/share/fonts/` and run `fc-cache -fv`.

The variants used throughout this project are **Rec Mono Casual** (Ghostty, VS Code editor) and **Rec Mono Linear** (Kitty, Waybar, Rofi, Hyprlock, mpv subtitles, notifications).

### VS Code

```bash
yay -S visual-studio-code-bin
```

### Git Tools

```bash
sudo pacman -S git-delta
```

---

## Configuration Setup

The automated installer handles all of this, but here are the manual steps if you prefer to cherry-pick components.

### Run the Installer (Recommended)

```bash
cd ~/dots-files
chmod +x install.sh
./install.sh
```

The interactive menu lets you select individual components. Each one backs up your existing configuration before overwriting.

### Manual Setup

#### Hyprland

```bash
mkdir -p ~/.config/hypr/scripts

cp ~/dots-files/hyprland/hyprland.conf   ~/.config/hypr/hyprland.conf
cp ~/dots-files/hyprland/hyprlock.conf   ~/.config/hypr/hyprlock.conf
cp ~/dots-files/hyprland/hyprpaper.conf  ~/.config/hypr/hyprpaper.conf
cp ~/dots-files/hyprland/hypridle.conf   ~/.config/hypr/hypridle.conf

# Scripts (color picker, search, screenshot)
cp ~/dots-files/hyprland/scripts/color-picker.sh  ~/.config/hypr/scripts/color-picker.sh
cp ~/dots-files/hyprland/scripts/rofi-search.sh   ~/.config/hypr/scripts/rofi-search.sh
cp ~/dots-files/hyprland/scripts/screenshot.sh    ~/.config/hypr/scripts/screenshot.sh
chmod +x ~/.config/hypr/scripts/*.sh
```

#### Wallpapers

Copy all wallpapers from the repository to your `~/Pictures/` directory:

```bash
mkdir -p ~/Pictures
cp -r ~/dots-files/assets/wallpaper/* ~/Pictures/
```

This gives you access to every wallpaper in the collection. Both `hyprpaper.conf` and `hyprlock.conf` reference `~/Pictures/wallpaper.jpg` as the default — you can change this path in those config files if you prefer a different one.

#### Waybar

```bash
mkdir -p ~/.config/waybar
cp ~/dots-files/waybar/config.jsonc ~/.config/waybar/config.jsonc
cp ~/dots-files/waybar/style.css    ~/.config/waybar/style.css   # Waybar style
```

#### Rofi

```bash
mkdir -p ~/.config/rofi
cp ~/dots-files/rofi/config.rasi ~/.config/rofi/config.rasi
```

#### Ghostty

```bash
mkdir -p ~/.config/ghostty
cp ~/dots-files/ghostty/config.ghostty ~/.config/ghostty/config
```

#### Kitty

```bash
mkdir -p ~/.config/kitty
cp ~/dots-files/kitty/kitty.conf ~/.config/kitty/kitty.conf
```

#### Zellij

```bash
mkdir -p ~/.config/zellij/themes
cp ~/dots-files/zellij/config.kdl                ~/.config/zellij/config.kdl
cp ~/dots-files/zellij/themes/catppuccin-macchiato.kdl  ~/.config/zellij/themes/catppuccin-macchiato.kdl
```

#### Dunst

```bash
mkdir -p ~/.config/dunst
cp ~/dots-files/dunst/dunstrc ~/.config/dunst/dunstrc
```

**Note:** Dunst in this project uses Catppuccin Mocha (`#1e1e2e`), not Macchiato. This is intentional — do not "fix" it without testing the contrast first.

#### SwayNC

```bash
mkdir -p ~/.config/swaync
cp ~/dots-files/swaync/config.json ~/.config/swaync/config.json
cp ~/dots-files/swaync/style.css   ~/.config/swaync/style.css   # SwayNC style
```

To use SwayNC instead of Dunst, replace `exec-once = /usr/bin/dunst` with `exec-once = swaync` in `hyprland.conf`.

#### Yazi

```bash
mkdir -p ~/.config/yazi
cp ~/dots-files/yazi/yazi.toml   ~/.config/yazi/yazi.toml
cp ~/dots-files/yazi/keymap.toml ~/.config/yazi/keymap.toml
cp ~/dots-files/yazi/theme.toml  ~/.config/yazi/theme.toml
```

Install the Catppuccin flavor via the `ya` package manager:

```bash
ya pack -a catppuccin/yazi:macchiato
```

Install the Catppuccin theme for bat (used by Yazi's file preview):

```bash
mkdir -p "$(bat --config-dir)/themes"
curl -fsSL "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme" \
  -o "$(bat --config-dir)/themes/Catppuccin Macchiato.tmTheme"
bat cache --build
```

#### mpv

```bash
mkdir -p ~/.config/mpv
cp ~/dots-files/mpv/mpv.conf   ~/.config/mpv/mpv.conf
cp ~/dots-files/mpv/input.conf ~/.config/mpv/input.conf
```

#### System Tools

```bash
mkdir -p ~/.config/btop/themes ~/.config/fastfetch ~/.config/atuin

cp ~/dots-files/btop/btop.conf               ~/.config/btop/btop.conf
cp ~/dots-files/fastfetch/fastfetch-config.jsonc  ~/.config/fastfetch/config.jsonc
cp ~/dots-files/atuin/config.toml             ~/.config/atuin/config.toml

# Catppuccin theme for btop
curl -fsSL https://github.com/catppuccin/btop/raw/main/themes/catppuccin_macchiato.theme \
  -o ~/.config/btop/themes/catppuccin_macchiato.theme
```

#### Zsh

```bash
cp ~/dots-files/zsh/.zshrc ~/.zshrc
source ~/.zshrc
```

The `.zshrc` already has the correct plugin list. If this is a fresh install, the plugins must be present before sourcing (install them first as shown in the Zsh section above).

Run `p10k configure` on first launch to generate your prompt.

#### Git

```bash
cp ~/dots-files/git/.gitconfig ~/.gitconfig
cp ~/dots-files/.gitignore ~/.gitignore
git config --global core.excludesfile ~/.gitignore
```

Update `~/.gitconfig` with your name and email before committing anything.

#### LazyGit

```bash
mkdir -p ~/.config/lazygit
cp ~/dots-files/lazygit/config.yml ~/.config/lazygit/config.yml
```

#### wlogout

```bash
mkdir -p ~/.config/wlogout
cp ~/dots-files/wlogout/style.css ~/.config/wlogout/style.css
cp ~/dots-files/wlogout/layout    ~/.config/wlogout/layout
```

#### Pyprland

```bash
mkdir -p ~/.config/pyprland
cp ~/dots-files/pyprland/pyprland.toml ~/.config/pyprland/pyprland.toml
```

Uncomment these two lines in `hyprland.conf` to enable:

```
exec-once = pypr
bind = $mainMod, grave, exec, pypr toggle term
```

#### VS Code

```bash
mkdir -p ~/.config/Code/User
cp ~/dots-files/vs\ code/settings.json ~/.config/Code/User/settings.json
```

#### SDDM

The theme installer in the [SDDM section](#sddm-display-manager) above handles configuration automatically.

If you prefer to configure it manually:

```bash
sudo cp ~/dots-files/sddm/sddm.conf /etc/sddm.conf.d/sddm.conf
sudo systemctl enable sddm
```

Then download and install the theme manually from
https://github.com/catppuccin/sddm/releases/latest

#### GRUB Theme

This script will:

- Clone the official Catppuccin GRUB theme
- Install it to `/boot/grub/themes/`
- Update `/etc/default/grub` with the theme path
- Regenerate `grub.cfg` (a backup of `/etc/default/grub` is created automatically)

```bash
~/dots-files/grub/install-grub-theme.sh
```

The theme will be visible on the next boot.

---

## Post-Installation

### First Boot

Reboot to reach the SDDM login screen, then select the Hyprland session:

```bash
sudo reboot
```

### Check Everything Works

| Shortcut         | Expected result                        |
| ---------------- | -------------------------------------- |
| `Super + T`      | Ghostty opens                          |
| `Super + B`      | Brave opens                            |
| `Super + E`      | Thunar opens                           |
| `Super + U`      | Dolphin opens                          |
| `Super + Y`      | Yazi opens in Ghostty                  |
| `Super + Space`  | Rofi launcher appears                  |
| `Super + L`      | Screen locks (Hyprlock)                |
| `Super + Escape` | wlogout power menu appears             |
| `Super + Tab`    | Workspace overview (Hyprexpo)          |
| `Super + grave`  | Pyprland scratchpad terminal slides in |
| Waybar           | Appears at the top of the screen       |

### First Neovim Launch

```vim
:checkhealth
:Mason
```

Use `I` to install language servers and formatters. The project uses ESLint and Prettier for JS/TS — install them via Mason or through your project's `node_modules`.

---

## Usage Guide

### Keyboard Shortcuts

#### Window Management

| Shortcut                   | Action                        |
| -------------------------- | ----------------------------- |
| `Super + Q`                | Close window                  |
| `Super + F`                | Toggle fullscreen + maximize  |
| `Super + V`                | Toggle floating               |
| `Super + Tab`              | Workspace overview (Hyprexpo) |
| `Super + H/J/K/L`          | Move focus (vim-style)        |
| `Super + Shift + H/J/K/L`  | Move window within layout     |
| `Super + mouse drag (LMB)` | Move floating window          |
| `Super + mouse drag (RMB)` | Resize window                 |

#### Applications

| Shortcut                | Action                           |
| ----------------------- | -------------------------------- |
| `Super + T`             | Ghostty (terminal)               |
| `Super + B`             | Brave (browser)                  |
| `Super + E`             | Thunar (file manager)            |
| `Super + U`             | Dolphin (file manager)           |
| `Super + Y`             | Yazi (terminal file manager)     |
| `Super + Space`         | Rofi (app launcher)              |
| `Super + Shift + Space` | Rofi web search (rofi-search.sh) |
| `Super + grave`         | Pyprland scratchpad terminal     |

#### System

| Shortcut                | Action                               |
| ----------------------- | ------------------------------------ |
| `Super + L`             | Lock screen (Hyprlock)               |
| `Super + Escape`        | wlogout power menu                   |
| `Super + P`             | Color picker (hyprpicker + Rofi)     |
| `Super + Shift + V`     | Clipboard history (cliphist + Rofi)  |
| `Super + Print`         | Region screenshot → satty annotation |
| `Super + Shift + Print` | Full screenshot → satty annotation   |

#### Workspaces

| Shortcut               | Action                        |
| ---------------------- | ----------------------------- |
| `Super + 1–0`          | Switch to workspace 1–10      |
| `Super + Shift + 1–0`  | Move window to workspace 1–10 |
| `Super + scroll wheel` | Cycle workspaces              |

#### Media & Volume

| Key                             | Action              |
| ------------------------------- | ------------------- |
| `XF86AudioRaiseVolume`          | Volume +5%          |
| `XF86AudioLowerVolume`          | Volume -5%          |
| `XF86AudioMute`                 | Toggle mute         |
| `XF86AudioMicMute`              | Toggle microphone   |
| `XF86MonBrightnessUp/Down`      | Brightness ±5%      |
| `XF86AudioNext/Prev/Play/Pause` | MPRIS media control |

### Yazi Shortcuts (in addition to defaults)

| Key        | Action                            |
| ---------- | --------------------------------- |
| `e`        | Open in Neovim                    |
| `.`        | Toggle hidden files               |
| `Space`    | Toggle selection                  |
| `yp`       | Copy path to clipboard            |
| `Ctrl + T` | Open Ghostty in current directory |
| `xx`       | Extract archive                   |

### Neovim Leader Key

The leader key is `Space`. Key group prefixes:

| Prefix      | Group                                    |
| ----------- | ---------------------------------------- |
| `<leader>f` | Find (files, text, buffers)              |
| `<leader>g` | Git (lazygit, hunks, blame)              |
| `<leader>c` | Code (LSP actions, TS tools)             |
| `<leader>a` | AI (Copilot Chat)                        |
| `<leader>r` | REST client (kulala.nvim, `.http` files) |
| `<leader>n` | Notifications                            |
| `<leader>u` | UI toggles                               |
| `<leader>x` | Diagnostics (Trouble)                    |

---

## Customization

### Configuration Files

| Tool           | Path                                          |
| -------------- | --------------------------------------------- |
| Hyprland       | `~/.config/hypr/hyprland.conf`                |
| Hyprlock       | `~/.config/hypr/hyprlock.conf`                |
| Hyprpaper      | `~/.config/hypr/hyprpaper.conf`               |
| Hypridle       | `~/.config/hypr/hypridle.conf`                |
| Scripts        | `~/.config/hypr/scripts/`                     |
| Waybar         | `~/.config/waybar/config.jsonc` + `style.css` |
| Rofi           | `~/.config/rofi/config.rasi`                  |
| Ghostty        | `~/.config/ghostty/config`                    |
| Kitty          | `~/.config/kitty/kitty.conf`                  |
| Zellij         | `~/.config/zellij/config.kdl`                 |
| Dunst          | `~/.config/dunst/dunstrc`                     |
| SwayNC         | `~/.config/swaync/config.json` + `style.css`  |
| Yazi           | `~/.config/yazi/`                             |
| mpv            | `~/.config/mpv/mpv.conf` + `input.conf`       |
| Neovim options | `~/.config/nvim/lua/config/options.lua`       |
| Neovim keymaps | `~/.config/nvim/lua/config/keymaps.lua`       |
| Neovim plugins | `~/.config/nvim/lua/plugins/`                 |
| Zsh            | `~/.zshrc`                                    |
| Git            | `~/.gitconfig`                                |
| LazyGit        | `~/.config/lazygit/config.yml`                |
| atuin          | `~/.config/atuin/config.toml`                 |
| btop           | `~/.config/btop/btop.conf`                    |
| fastfetch      | `~/.config/fastfetch/config.jsonc`            |
| VS Code        | `~/.config/Code/User/settings.json`           |
| wlogout        | `~/.config/wlogout/style.css`                 |
| Pyprland       | `~/.config/pyprland/pyprland.toml`            |
| SDDM           | `/etc/sddm.conf.d/sddm.conf`                  |

### Color Palette Reference

All tools use **Catppuccin Macchiato**. The most-used values:

| Name     | Hex       | Used for                         |
| -------- | --------- | -------------------------------- |
| base     | `#24273a` | Backgrounds                      |
| mantle   | `#1e2030` | Input bars, panels               |
| text     | `#cad3f5` | Primary text                     |
| blue     | `#8aadf4` | Borders, focus, clock            |
| mauve    | `#c6a0f6` | Active workspace, Rofi selection |
| green    | `#a6da95` | Success states                   |
| red      | `#ed8796` | Errors, close button             |
| yellow   | `#eed49f` | Warnings                         |
| surface0 | `#363a4f` | Hover backgrounds                |
| overlay0 | `#6e738d` | Inactive/dimmed text             |

### Saving Changes

```bash
cd ~/dots-files
git add .
git commit -m "chore: update configuration"
git push origin main
```

---

## Additional Resources

### Related Guides

- [Arch Linux Installation](./ARCH_LINUX_INSTALLATION.md)
- [Swap File Creation](./SWAP_FILE_CREATION.md)
- [Uninstalling Linux on Dual Boot](./UNINSTALL_LINUX_ON_DUAL_BOOT.md)
- [Useful Resources](./USEFUL_RESOURCES.md)

### Documentation

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Arch Wiki](https://wiki.archlinux.org/)
- [LazyVim Documentation](https://www.lazyvim.org/)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Catppuccin Palette](https://catppuccin.com/palette)
