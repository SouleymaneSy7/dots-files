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

## Introduction

This guide details the installation and configuration of [Hyprland](https://hypr.land/), a dynamic Wayland compositor, on a fresh Arch Linux installation.

### Environment Overview

This setup includes:

- **Browser**: Brave
- **Terminal**: Ghostty with Zsh and Oh-My-Zsh
- **Application Launcher**: Rofi
- **Status Bar**: Waybar
- **Wallpaper Manager**: Hyprpaper
- **Screen Lock**: Hyprlock
- **Idle Manager**: Hypridle
- **File Manager**: Thunar
- **Text Editor**: Neovim with LazyVim
- **Notification Daemon**: Dunst
- **Logout Menu**: wlogout

All configurations are managed through the [dots-files](https://github.com/souleymanesy7/dots-files) repository.

## Prerequisites

- A fresh Arch Linux installation with base system installed
- Internet connection
- Basic familiarity with the Linux command line
- Sudo privileges

## System Preparation

### Update System

Update your Arch Linux system to the latest packages:

```bash
sudo pacman -Syu
```

### Install Base Development Tools

Install Git and base development tools:

```bash
sudo pacman -S base-devel git
```

Configure Git:

```bash
git config --global user.name "Your name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
git config --global core.longpaths true
```

### Install AUR Helper (Yay)

Yay simplifies installation of packages from the Arch User Repository:

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si PKGBUILD
cd ~
rm -rf yay
```

### Cloning the dots-files Repository

Clone the configuration repository:

```bash
git clone https://github.com/souleymanesy7/dots-files.git ~/dots-files
```

### Install System Services

#### Audio System (Pipewire)

```bash
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
```

#### Fonts

Install Nerd Fonts for proper icon display:

```bash
sudo pacman -S ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-firacode-nerd \
  ttf-ibmplex-mono-nerd ttf-iosevka-nerd ttf-jetbrains-mono-nerd ttf-meslo-nerd \
  ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono

fc-cache -fv
```

## Hyprland Installation

### Installing the Main Package

```bash
sudo pacman -S hyprland
```

### Installing Wayland Dependencies

```bash
sudo pacman -S xdg-desktop-portal-hyprland qt5-wayland qt6-wayland
```

### Installing Polkit

To manage system permissions:

```bash
sudo pacman -S polkit-kde-agent
```

### Additional Hyprland Tools

Install screen locking and wallpaper management:

### Hyprpaper

```bash
sudo pacman -S hyprpaper
```

### Hyprlock and Hypridle

For screen locking and idle management:

```bash
sudo pacman -S hyprlock hypridle
```

### System Utilities

Install brightness, volume, notification, and screenshot tools:

```bash
# Brightness control
sudo pacman -S brightnessctl

# Volume control
sudo pacman -S pamixer pavucontrol

# Notifications
sudo pacman -S dunst

# Screenshots
sudo pacman -S grim slurp
```

### First Launch Test (Optional)

Test Hyprland from the terminal:

```bash
Hyprland
```

Hyprland will create its default configuration in `~/.config/hypr/`. Exit with `SUPER + M`.

## Essential Applications

### Browser

```bash
yay -S brave-bin
```

### Terminal Emulator

```bash
yay -S ghostty
```

### Shell (Zsh)

#### Install Zsh

```bash
sudo pacman -S zsh zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting
```

Change your default shell to `Zsh`:

```bash
chsh -s $(which zsh)
```

#### Install Oh-My-Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### Install Zsh Plugins

Install recommended plugins:

- [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete)

  ```bash
  git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
  ```

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

  ```bash
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  ```

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

  ```bash
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
  ```

- [zsh-fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)

  ```bash
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
  ```

### Application Launcher

```bash
sudo pacman -S rofi-wayland
```

### Status Bar

```bash
sudo pacman -S waybar
```

### Logout Menu

```bash
yay -S wlogout
```

### File Manager

```bash
sudo pacman -S thunar thunar-volman thunar-archive-plugin gvfs
```

### Text Editor (Neovim)

#### Install Neovim and Dependencies

Install `Neovim` and all required dependencies:

```bash
# Core Neovim and essential tools (required)
sudo pacman -S neovim ripgrep fd curl

# Tree-sitter CLI for better syntax highlighting
sudo pacman -S tree-sitter-cli

# Optional but highly recommended tools
sudo pacman -S lazygit # Git TUI - highly recommended for LazyVim

```

#### Install LazyVim

```bash
# Backup existing Neovim files (required)
mv ~/.config/nvim{,.bak}

# Optional but recommended - backup data, state, and cache
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

# Clone the LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Remove the .git folder so you can add it to your own repo later
rm -rf ~/.config/nvim/.git

```

Additional dependencies like `language servers`, `formatters`, and `linters` can be installed later through `LazyVim's Mason` plugin after setup.

## Configuration Setup

### Create Configuration Directories

```bash
mkdir -p ~/.config/{hypr,waybar,rofi,ghostty,dunst,nvim}
```

### Apply Dotfiles

#### Hyprland

```bash
cp -r ~/dots-files/hyprland/* ~/.config/hypr/
```

This includes:
- `hyprland.conf` - Main configuration
- `hyprpaper.conf` - Wallpaper settings
- `hyprlock.conf` - Lock screen settings
- `hypridle.conf` - Idle management

#### Waybar

```bash
cp -r ~/dots-files/waybar/new/* ~/.config/waybar/
```

Includes `config` and `style.css` files.

#### Rofi

```bash
cp -r ~/dots-files/rofi/new/* ~/.config/rofi/
```

#### Ghostty

```bash
cp -r ~/dots-files/ghostty/* ~/.config/ghostty/
```

#### Dunst

```bash
cp -r ~/dots-files/dunst/* ~/.config/dunst/
```

#### Zsh

```bash
cp ~/dots-files/zsh/.zshrc ~/.zshrc
```

Plugins configurations:

Enable plugins by adding them to the `.zshrc` file:

- open the `.zshrc` with `nano` or `vim`
- Find the line which says `plugins=(git)`
- Replace that line with:

```zshrc
plugins=(
  git
  zsh-autocomplete
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
 )
```

Reload configuration:

```bash
source ~/.zshrc
```

#### Neovim

Copy the Neovim configuration:

```bash
# Backup existing configuration if it exists
if [ -d ~/.config/nvim ]; then
    mv ~/.config/nvim ~/.config/nvim.bak
fi

# Copy configuration from dots-files
cp -r ~/dots-files/nvim ~/.config/nvim
```

Start `Neovim` to automatically install all plugins:

```bash
nvim
```

**What to Expect:**

- On first launch, `LazyVim` will automatically install all plugins. This may take 2-5 minutes.
- You'll see a `Lazy.nvim` window showing installation progress.
- Wait until all plugins are installed (you'll see "✓" checkmarks).
- Once complete, press `q` to close the Lazy window.

#### Wallpapers

```bash
mkdir -p ~/Pictures
cp -r ~/dots-files/assets/wallpaper/* ~/Pictures/
```

Ensure wallpaper paths in `~/.config/hypr/hyprpaper.conf` match the copied files.

## Post-Installation

### Launch Hyprland

#### With Display Manager

If using a display manager like SDDM:

```bash
sudo reboot
```

Select Hyprland from the session menu.

#### Without Display Manager

From TTY:

```bash
Hyprland
```

### Verify Installation

Test each component:

1. **Terminal**: `SUPER + T` → Opens Ghostty
2. **Waybar**: Should appear at the top of the screen
3. **Application Launcher**: `SUPER + SPACE` → Opens Rofi
4. **Browser**: `SUPER + B` → Opens Brave
5. **File Manager**: `SUPER + E` → Opens Thunar

### Configure Neovim (First Run)

Inside Neovim, check system health:

```vim
:LazyHealth
```

Install language servers and tools:

```vim
:Mason
```

Mason navigation:
- `I` - Install package
- `X` - Uninstall package
- `U` - Update package
- `/` - Search
- `q` - Quit

## Usage Guide

### Keyboard Shortcuts

These keyboard shortcuts are based on the configuration from the dots-files repository.

#### Window Management
- `SUPER + Q` - Close active window
- `SUPER + F` - Toggle fullscreen
- `SUPER + V` - Toggle floating mode
- `SUPER + M` - Exit Hyprland

#### Applications
- `SUPER + T` - Open terminal (Ghostty)
- `SUPER + B` - Open browser (Brave)
- `SUPER + E` - Open file manager (Thunar)
- `SUPER + SPACE` - Open application launcher (Rofi)

#### Workspaces
- `SUPER + 1-10` - Switch to workspace
- `SUPER + SHIFT + 1-10` - Move window to workspace

#### System
- `SUPER + L` - Lock screen
- `SUPER + ESCAPE` - Logout menu
- `PRINT` - Selective screenshot
- `SUPER + PRINT` - Full screenshot


## Customization

### Configuration Files

All configurations are located in `~/.config/`:

- **Hyprland**: `~/.config/hypr/hyprland.conf`
- **Waybar**: `~/.config/waybar/config` and `~/.config/waybar/style.css`
- **Rofi**: `~/.config/rofi/config.rasi`
- **Ghostty**: `~/.config/ghostty/config`
- **Zsh**: `~/.zshrc`
- **Neovim**: `~/.config/nvim/lua/`
  - `lua/config/options.lua` - Neovim options
  - `lua/config/keymaps.lua` - Custom keybindings
  - `lua/config/lazy.lua` - Lazy.nvim setup
  - `lua/plugins/` - Custom plugins

For LazyVim customization, refer to the [official documentation](https://www.lazyvim.org/configuration).

### Saving Changes

Commit your modifications to the dots-files repository:

```bash
cd ~/dots-files
git add .
git commit -m "Update configurations"
git push origin main
```

## Additional Resources

### Related Guides

- [Arch Linux Installation Guide](./ARCH_LINUX_INSTALLATION.md)
- [Swap File Creation](./SWAP_FILE_CREATION.md)
- [Uninstalling Linux on Dual Boot](./UNINSTALL_LINUX_ON_DUAL_BOOT.md)
- [Useful Resources](./USEFUL_RESOURCES.md)

### Documentation

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Arch Wiki](https://wiki.archlinux.org/)
- [LazyVim Documentation](https://www.lazyvim.org/)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
