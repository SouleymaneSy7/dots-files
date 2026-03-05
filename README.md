# Dotfiles for Arch Linux with Hyprland

Personal dotfiles for an Arch Linux setup built around [Hyprland](https://hyprland.org). Every configuration file is fully annotated with instructional comments — making the setup easy to understand, adapt, and extend.

Themed consistently with **Catppuccin Macchiato** and **Rec Mono** across all tools.

---

## Stack

| Tool                                             | Role                             |
| ------------------------------------------------ | -------------------------------- |
| [Hyprland](https://hyprland.org)                 | Wayland compositor               |
| [Waybar](https://github.com/Alexays/Waybar)      | Status bar                       |
| [Hyprlock](https://github.com/hyprwm/hyprlock)   | Screen locker                    |
| [Hyprpaper](https://github.com/hyprwm/hyprpaper) | Wallpaper daemon                 |
| [Dunst](https://dunst-project.org)               | Notification daemon              |
| [Rofi](https://github.com/davatorium/rofi)       | Application launcher             |
| [Ghostty](https://ghostty.org)                   | Terminal emulator                |
| [Kitty](https://sw.kovidgoyal.net/kitty/)        | Terminal emulator (secondary)    |
| [Neovim](https://neovim.io)                      | Editor (custom lazy.nvim config) |
| [Zsh + Oh My Zsh](https://ohmyz.sh)              | Shell                            |
| [VS Code](https://code.visualstudio.com)         | GUI editor                       |

---

## Structure

```
dots-files/
├── assets/wallpaper/
├── dunst/                    # dunstrc
├── ghostty/                  # config
├── hyprland/                 # hyprland.conf · hyprlock.conf · hyprpaper.conf
├── kitty/                    # kitty.conf
├── nvim/lua/                 # config/ · plugins/
├── rofi/                     # catppuccin-macchiato.rasi · black-and-white.rasi
├── vs code/                  # settings.json
├── waybar/                   # config · style.css
├── zsh/                      # .zshrc
├── stylua.toml
├── ARCH_LINUX_INSTALLATION.md
├── HYPERLAND_INSTALLATION_GUIDE.md
├── SWAP_FILE_CREATION.md
├── UNINSTALL_LINUX_ON_DUAL_BOOT.md
└── USEFUL_RESOURCES.md
```

---

## Installation

```bash
# Clone
git clone https://github.com/SouleymaneSy7/dots-files.git ~/dots-files

# Back up existing configs
cp -r ~/.config/hypr ~/.config/hypr.bak

# Copy
cp -r ~/dots-files/hyprland/*  ~/.config/hypr/
cp -r ~/dots-files/waybar/*    ~/.config/waybar/
cp -r ~/dots-files/dunst/*     ~/.config/dunst/
cp -r ~/dots-files/rofi/*      ~/.config/rofi/
cp -r ~/dots-files/ghostty/*   ~/.config/ghostty/
cp -r ~/dots-files/kitty/*     ~/.config/kitty/
cp -r ~/dots-files/nvim/*      ~/.config/nvim/
cp    ~/dots-files/zsh/.zshrc  ~/.zshrc

# Reload
hyprctl reload
```

---

## Guides

| Guide                                                             | Description                                                                    |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| [Arch Linux Installation](./ARCH_LINUX_INSTALLATION.md)           | Full base system install for MBR/Legacy BIOS, including dual-boot with Windows |
| [Hyprland Installation](./HYPERLAND_INSTALLATION_GUIDE.md)        | Setting up the complete Hyprland stack on a fresh Arch install                 |
| [Swap File Creation](./SWAP_FILE_CREATION.md)                     | Creating, sizing, and persisting a swap file across reboots                    |
| [Uninstall Linux on Dual Boot](./UNINSTALL_LINUX_ON_DUAL_BOOT.md) | Restoring the Windows bootloader and reclaiming Linux partitions               |
| [Useful Resources](./USEFUL_RESOURCES.md)                         | Curated docs, wikis, and community references for this stack                   |

---

## Author

[**Souleymane Sy**](https://github.com/SouleymaneSy7) — Frontend Developer open to freelance collaborations.
