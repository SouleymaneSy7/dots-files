# Dotfiles for Arch Linux with Hyprland

This repository contains my personalized dot-files for an [Arch Linux](https://wiki.archlinux.org) setup using the
[Hyprland](https://hyprland.org) window manager, [LazyVim](https://www.lazyvim.org) for Neovim, [Kitty](https://sw.kovidgoyal.net/kitty/) as the terminal, [Rofi](https://github.com/davatorium/rofi) as the application launcher, and [Hyprpaper](https://github.com/hyprwm/hyprpaper) for wallpaper management.

## Overview

This configuration aims to provide a lightweight, fast, and visually appealing desktop environment based on Hyprland. The chosen tools and customizations prioritize productivity and simplicity while maintaining a modern and cohesive look.

For Arch Linux installation, see the: [Arch Linux Installation Guide](ARCH_LINUX_INSTALLATION.md)

Additional resources: [Useful Resources](USEFUL_RESOURCES.md).

For Uninstalling Linux, see the: [Linux Uninstall On Dual Boot Guide](UNINSTALL_LINUX_ON_DUAL_BOOT.md)

### Included Tools

- **Hyprland**: A highly configurable and performant Wayland window manager.
- **LazyVim**: A modern, modular configuration for Neovim, ideal for development and text editing.
- **Kitty**: A fast, GPU-accelerated terminal emulator with extensive customization options.
- **Rofi**: A lightweight application launcher with a custom theme.
- **Hyprpaper**: A utility for managing dynamic wallpapers with Hyprland.

## Repository Structure

```
.dotfiles/
├── hyprland/ # Hyprland configuration
├── nvim/ # LazyVim configuration for Neovim
├── kitty/ # Kitty configuration
├── rofi/ # Rofi configuration
├── hyprpaper/ # Hyprpaper configuration
├── ARCH_LINUX_INSTALLATION.md # Arch Linux Installation Guide
├── README.md  # This file
├── UNINSTALL_LINUX_ON_DUAL_BOOT.md # Delete Linux on dual-boot
└── USEFUL_RESOURCES.md        # Additional resources
```

## Installation

1. **Prerequisites**:
   - Arch Linux installed.
   - Required packages: `hyprland`, `neovim`, `kitty`, `waybar`, `rofi`, `hyprpaper`, `hypridle`, `hyprlock`.
   - Install necessary dependencies for each tool (refer to their official documentation).

2. **Clone the Repository**:

   ```bash
   git clone https://github.com/souleymanesy7/dotfiles.git ~/.dotfiles
   ```

3. **Apply Configurations**:
   - Copy the configuration files to their respective directories (e.g., `~/.config/hypr/`, `~/.config/nvim/`, etc.).

4. **Restart Hyprland**:
   - Ensure Hyprland is running, then reload the configuration with `hyprctl reload`.

## Customization

- **Hyprland**: Edit `hypr/hyprland.conf` to adjust keybindings, window rules, or animations.
- **LazyVim**: Modify `nvim/lua/` to customize plugins, configs and settings for LazyVim.
- **Kitty**: Update `kitty/kitty.conf` to change themes, fonts, or terminal behavior.
- **Rofi**: Adjust themes and scripts in `rofi/` to personalize the launcher’s appearance.
- **Hyprpaper**: Edit `hyprpaper/hyprpaper.conf` to change wallpapers or transitions.
