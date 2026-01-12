# Hyprland Installation and Configuration on Arch Linux

## Table of Contents

1. [Introduction](#introduction)
2. [System Preparation](#system-preparation)
3. [Hyprland Installation](#hyprland-installation)
4. [Initial Configuration](#initial-configuration)
5. [Installing Essential Tools](#installing-essential-tools)
6. [Applying Configurations](#applying-configurations)
7. [Finalization](#finalization)

## Introduction

This guide details the installation and configuration of [Hyprland](https://hypr.land/), a dynamic Wayland compositor, on a fresh Arch Linux installation. We will set up a complete environment with the following tools:

- **Browser**: `Brave`
- **Terminal**: `Ghostty` with `Zsh` and `Oh-My-Zsh`
- **Application Launcher**: `Rofi`
- **Status Bar**: `Waybar`
- **Wallpaper**: `Hyprpaper`
- **File Manager**: `Thunar`
- **Text Editor**: `Neovim` with `LazyVim`
- **Theme**: `Catppuccin Mocha`

All configurations will be fetched directly from the [dots-files](https://github.com/souleymanesy7/dots-files) repository.

## System Preparation

### System Update

Start by updating your Arch Linux system:

```bash
sudo pacman -Syu
```

### Installing Git and Development Tools

Git is essential for cloning repositories and installing the `AUR` helper:

```bash
sudo pacman -S git
```

### Installing Yay (AUR Helper)

`Yay` facilitates package installation from the `AUR`:

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si PKGBUILD
cd ~
```

### Cloning the dots-files Repository

Clone the configuration repository:

```bash
git clone https://github.com/souleymanesy7/dots-files.git ~/dots-files
```

### Installing Audio System

Install `Pipewire` for modern audio management:

```bash
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
```

### Installing Fonts

Nerd Fonts are essential for proper icon display:

```bash
sudo pacman -S ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-firacode-nerd ttf-ibmplex-mono-nerd ttf-iosevka-nerd ttf-jetbrains-mono-nerd ttf-meslo-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono

fc-cache -f
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

### First Launch (Optional)

If you don't have a display manager, you can launch `Hyprland` from the `Terminal` to test:

```bash
Hyprland
```

`Hyprland` will automatically create its configuration in `~/.config/hypr/`. You can exit with `SUPER + M`.

## Initial Configuration

### Creating Configuration Directories

Create necessary directories if they don't exist yet:

```bash
mkdir -p ~/.config/{hypr,waybar,rofi,ghostty,dunst,nvim}
```

## Installing Essential Tools

### Brave Browser

```bash
yay -S brave-bin
```

### Ghostty Terminal

```bash
yay -S ghostty
```

### Zsh and Oh-My-Zsh

Installing `Zsh`:

```bash
sudo pacman -S zsh zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting
```

Change your default shell to `Zsh`:

```bash
chsh -s $(which zsh)
```

Installing `Oh-My-Zsh`

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

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

### Rofi (Wayland Version)

```bash
sudo pacman -S rofi-wayland
```

### Waybar

```bash
sudo pacman -S waybar
```

### Hyprpaper

```bash
sudo pacman -S hyprpaper
```

### Hyprlock and Hypridle

For screen locking and idle management:

```bash
sudo pacman -S hyprlock hypridle
```

### Thunar

```bash
sudo pacman -S thunar thunar-volman thunar-archive-plugin gvfs
```

### Neovim with LazyVim

Installing `Neovim` and all required dependencies:

```bash
# Core Neovim and essential tools (required)
sudo pacman -S neovim ripgrep fd curl

# Tree-sitter CLI for better syntax highlighting
sudo pacman -S tree-sitter-cli

# Optional but highly recommended tools
sudo pacman -S lazygit # Git TUI - highly recommended for LazyVim

```

Additional dependencies like `language servers`, `formatters`, and `linters` can be installed later through `LazyVim's Mason` plugin after setup.

### Additional Utilities

```bash
# Brightness control
sudo pacman -S brightnessctl

# Volume control
sudo pacman -S pamixer

# Notifications
sudo pacman -S dunst

# Screenshots
sudo pacman -S grim slurp
```

## Applying Configurations

### Zsh Configuration

Copy the configuration from the `dots-files` repository:

```bash
cp ~/dots-files/zsh/.zshrc ~/.zshrc
```

Reload the `Zsh` configuration:

```bash
source ~/.zshrc
```

### Ghostty Configuration

Copy the `Ghostty` configuration:

```bash
cp ~/dots-files/ghostty/config ~/.config/ghostty/config
```

### Hyprland Configuration

Copy all `Hyprland` configurations:

```bash
cp -r ~/dots-files/hyprland/* ~/.config/hypr/
```

This will include:

- `hyprland.conf`: Main Hyprland configuration
- `hyprpaper.conf`: Wallpaper configuration
- `hyprlock.conf`: Screen lock configuration
- `hypridle.conf`: Idle management configuration

### Waybar Configuration

Copy the `Waybar` configuration:

```bash
cp -r ~/dots-files/waybar/new/* ~/.config/waybar/
```

This will include:

- `config`: Waybar modules configuration
- `style.css`: CSS styles for Waybar

### Rofi Configuration

Copy the `Rofi` configuration:

```bash
cp -r ~/dots-files/rofi/new/* ~/.config/rofi/
```

### Dunst Configuration

Copy `Dunst` configuration:

```bash
cp -r ~/dots-files/dunst/* ~/.config/dunst/
```

### Neovim Configuration (LazyVim)

Install the LazyVim distro:

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

Copy the Neovim configuration:

```bash
# Backup existing configuration if it exists
if [ -d ~/.config/nvim ]; then
    mv ~/.config/nvim ~/.config/nvim.bak
fi

# Copy configuration from dots-files
cp -r ~/dots-files/nvim ~/.config/nvim
```

#### First Launch

Start `Neovim` to automatically install all plugins:

```bash
nvim

```

**What to Expect:**

- On first launch, `LazyVim` will automatically install all plugins. This may take 2-5 minutes.
- You'll see a `Lazy.nvim` window showing installation progress.
- Wait until all plugins are installed (you'll see "✓" checkmarks).
- Once complete, press `q` to close the Lazy window.

#### Post-Installation Health Check

After the initial plugin installation, run a health check:

```bash
# Inside Neovim, run:
:LazyHealth

```

This will check if everything is working correctly and show any missing dependencies.

#### Installing Language Servers and Tools

`LazyVim` uses `Mason` to manage `LSPs`, `formatters`, and `linters`. To install tools:

```bash
# Inside Neovim, run:
:Mason

```

Navigation in Mason:

- `I` - Install package
- `X` - Uninstall package
- `U` - Update package
- `/` - Search
- `q` - Quit

#### Customizing LazyVim

To customize LazyVim, edit the files in `~/.config/nvim/lua/`:

- `lua/config/options.lua` - Neovim options
- `lua/config/keymaps.lua` - Custom keybindings
- `lua/config/lazy.lua` - Lazy.nvim setup
- `lua/plugins/` - Add your custom plugins here

Refer to the [LazyVim documentation](https://www.lazyvim.org/configuration) for detailed customization options.

### Wallpapers Configuration

Copy wallpapers from the repository:

```bash
mkdir -p ~/Pictures
cp -r ~/dots-files/assets/wallpaper/* ~/Pictures/
```

If you're using `Hyprpaper`, make sure the paths in `~/.config/hypr/hyprpaper.conf` match the copied wallpapers.

## Finalization

### Starting Hyprland

If you're using a display manager (like `SDDM`), simply reboot:

```bash
sudo reboot
```

Otherwise, launch `Hyprland` from the `TTY`:

```bash
Hyprland
```

### Verifying Everything Works

Once in `Hyprland`, verify that everything is working:

1. **`Terminal`**: Press `SUPER + T` to open Ghostty
2. **`Waybar`**: Should be visible at the top of the screen
3. **`Rofi`**: Press `SUPER + SPACE` to open the application launcher
4. **`Browser`**: Press `SUPER + B` to open Brave
5. **`File Manager`**: Press `SUPER + E` to open Thunar

### Main Keyboard Shortcuts

Here are the essential keyboard shortcuts (according to the dots-files configuration):

- `SUPER + T`: Open terminal (Ghostty)
- `SUPER + SPACE`: Open Rofi (application launcher)
- `SUPER + B`: Open Brave (browser)
- `SUPER + E`: Open Thunar (file manager)
- `SUPER + Q`: Close active window
- `SUPER + M`: Exit Hyprland
- `SUPER + F`: Toggle fullscreen
- `SUPER + V`: Toggle floating mode
- `SUPER + L`: Lock screen (Hyprlock)
- `SUPER + 1-10`: Switch workspace
- `SUPER + SHIFT + 1-10`: Move window to workspace
- `PRINT`: Selective screenshot
- `SUPER + PRINT`: Full screenshot

## Customization

All your configurations are now in `~/.config/`. You can modify them according to your preferences:

- **`Hyprland`**: Edit `~/.config/hypr/hyprland.conf`
- **`Waybar`**: Edit `~/.config/waybar/config` and `~/.config/waybar/style.css`
- **`Rofi`**: Edit `~/.config/rofi/config.rasi`
- **`Ghostty`**: Edit `~/.config/ghostty/config`
- **`Zsh`**: Edit `~/.zshrc`
- **`Neovim`**: Edit files in `~/.config/nvim/lua/`

Don't forget to save your personal modifications in the dots-files repository:

```bash
cd ~/dots-files
git add .
git commit -m "Update configurations"
git push origin main
```

## Additional Resources

Also check out the other guides in the dots-files repository:

- [Arch Linux Installation Guide](./ARCH_LINUX_INSTALLATION.md)
- [Swap File Creation](./SWAP_FILE_CREATION.md)
- [Uninstalling Linux on Dual Boot](./UNINSTALL_LINUX_ON_DUAL_BOOT.md)
- [Useful Resources](./USEFUL_RESOURCES.md)

