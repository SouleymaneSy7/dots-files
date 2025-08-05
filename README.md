# Dotfiles for Arch Linux with Hyprland

This repository contains my personalized dotfiles for an [Arch Linux](https://wiki.archlinux.org) setup, featuring the [Hyprland](https://hyprland.org) Wayland window manager, [LazyVim](https://www.lazyvim.org) for Neovim, [Kitty](https://sw.kovidgoyal.net/kitty/) as the terminal emulator, [Rofi](https://github.com/davatorium/rofi) as the application launcher, [Hyprpaper](https://github.com/hyprwm/hyprpaper) for wallpaper management, [Waybar](https://github.com/Alexays/Waybar) for a customizable status bar, [Hyprlock](https://github.com/hyprwm/hyprlock) for screen locking, and [Hypridle](https://github.com/hyprwm/hypridle) for idle management.

## Overview

This configuration delivers a lightweight, performant, and visually cohesive desktop environment tailored for productivity and simplicity. Built around Hyprland, it combines modern tools with custom settings to create a streamlined and aesthetically pleasing workflow on Arch Linux.

## Additional Resources

- **[Arch Linux Installation Guide](ARCH_LINUX_INSTALLATION.md)**: Step-by-step instructions for installing Arch Linux.
- **[Swap File Creation Guide](SWAP_FILE_CREATION.md)**: Instructions for creating and managing swap files to optimize memory usage.
- **[Uninstalling Linux on Dual Boot](UNINSTALL_LINUX_ON_DUAL_BOOT.md)**: Guide for safely removing Linux from a dual-boot system.
- **[Useful Resources](USEFUL_RESOURCES.md)**: Curated links to documentation and guides for the tools used in this setup.

## Included Tools

- **Hyprland**: A dynamic and highly configurable Wayland window manager known for its performance and smooth animations.
- **LazyVim**: A modular Neovim configuration with a rich plugin ecosystem, optimized for coding and text editing.
- **Kitty**: A fast, GPU-accelerated terminal emulator with extensive customization for themes, fonts, and layouts.
- **Rofi**: A lightweight application launcher with a custom theme for quick access to apps and scripts.
- **Hyprpaper**: A utility for managing dynamic wallpapers, seamlessly integrated with Hyprland.
- **Waybar**: A highly customizable status bar for Wayland, displaying system information like CPU, memory, and network status.
- **Hyprlock**: A secure and visually appealing screen locker for Hyprland, supporting custom themes and animations.
- **Hypridle**: An idle management daemon for Hyprland, enabling actions like screen dimming or locking after inactivity.

## Repository Structure

```
.dotfiles/
├── hyprland/              # Hyprland and related configurations
│   ├── hypr/              # Core Hyprland window manager configuration
│   ├── hyprpaper/         # Hyprpaper wallpaper configuration
│   ├── hyprlock/          # Hyprlock screen locker configuration
│   ├── hypridle/          # Hypridle idle management configuration
├── nvim/                  # LazyVim configuration for Neovim
├── kitty/                 # Kitty terminal configuration
├── rofi/                  # Rofi launcher configuration
├── waybar/                # Waybar status bar configuration
├── ARCH_LINUX_INSTALLATION.md        # Arch Linux installation guide
├── SWAP_FILE_CREATION.md             # Swap file creation guide
├── README.md                         # This file
├── UNINSTALL_LINUX_ON_DUAL_BOOT.md   # Guide for removing Linux from dual-boot
└── USEFUL_RESOURCES.md               # Additional resources
```

## Installation

### Prerequisites

- A working Arch Linux installation.
- Required packages: `hyprland`, `neovim`, `kitty`, `waybar`, `rofi`, `hyprpaper`, `hyprlock`, `hypridle`.
- Install dependencies for each tool (refer to their official documentation, e.g., [Hyprland Wiki](https://wiki.hyprland.org) or [Waybar Examples](https://github.com/Alexays/Waybar/wiki/Examples)).

### Backup Recommendation

Before applying new configurations, back up your existing configuration files (e.g., `~/.config/hypr/`, `~/.config/nvim/`) to avoid accidental data loss.

### Steps

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/souleymanesy7/dotfiles.git ~/.dotfiles  # Clones the repository to ~/.dotfiles
   ```

2. **Apply Configurations**:
   Copy the configuration files to their respective directories:

3. **Restart Hyprland**:
   Reload Hyprland to apply the new configuration:

   ```bash
   hyprctl reload  # Reloads Hyprland configuration without restarting the session
   ```

## Customization

Customize the setup to suit your preferences:

- **Hyprland**: Edit `~/.config/hypr/hyprland.conf` to modify keybindings (e.g., `bind = SUPER, T, exec, kitty`), window rules, or animation settings (e.g., `bezier` curves for transitions).
- **Hyprpaper**: Update `~/.config/hyprpaper/hyprpaper.conf` to set wallpaper paths (e.g., `wallpaper = ,/path/to/image.jpg`) or transition effects.
- **Hyprlock**: Modify `~/.config/hyprlock/hyprlock.conf` to change lock screen appearance, such as background images or text styles.
- **Hypridle**: Configure `~/.config/hypridle/hypridle.conf` to set idle timeouts (e.g., `timeout = 300`) or actions like locking the screen with `hyprlock`.
- **LazyVim**: Modify `~/.config/nvim/lua/` to add or remove plugins, adjust keymaps (e.g., `<leader>ff` for file search), or tweak settings like auto-indentation.
- **Kitty**: Update `~/.config/kitty/kitty.conf` to change themes (e.g., `theme = Gruvbox`), fonts (e.g., `font_family = JetBrains Mono`), or tab behavior.
- **Rofi**: Adjust `~/.config/rofi/` to customize themes (e.g., `theme = ~/.config/rofi/custom.rasi`) or add scripts for power menus.
- **Waybar**: Modify `~/.config/waybar/config` to add modules (e.g., battery, clock) or edit `style.css` for custom colors and layouts.

## Contributing

Contributions are welcome! If you have suggestions for improving this dotfiles setup, please:

- Open an issue on the [GitHub repository](https://github.com/souleymanesy7/dotfiles) to discuss changes.
- Submit a pull request with your proposed modifications, ensuring they align with the lightweight and modular philosophy of this setup.
