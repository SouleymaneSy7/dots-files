# dots-files

Arch Linux + Hyprland setup themed around [Catppuccin Macchiato](https://catppuccin.com). The configs are commented — not just what a setting does, but why it's set that way, what breaks if you change it, and what the alternatives are.

There's an interactive installer with 25 toggle-able components. Take what's useful, ignore the rest. Existing configs get backed up before anything is overwritten.

---

## Quick start

```bash
git clone https://github.com/SouleymaneSy7/dots-files.git ~/dots-files
cd ~/dots-files
./install.sh
```

---

## What's in here

**Desktop**

| Tool                                                           | Role                                                                     |
| -------------------------------------------------------------- | ------------------------------------------------------------------------ |
| [Hyprland](https://hyprland.org)                               | Wayland compositor — dwindle tiling, Super key, vim navigation (h/j/k/l) |
| [Waybar](https://github.com/Alexays/Waybar)                    | Status bar: workspaces, MPRIS media, volume, clock with calendar tooltip |
| [Rofi](https://github.com/davatorium/rofi)                     | App launcher, window switcher, clipboard picker                          |
| [Hyprlock](https://github.com/hyprwm/hyprlock)                 | Lock screen                                                              |
| [Hyprpaper](https://github.com/hyprwm/hyprpaper)               | Wallpaper daemon                                                         |
| [Hypridle](https://github.com/hyprwm/hypridle)                 | Idle: dim (60s) → lock (120s) → DPMS off (300s) → suspend (900s)         |
| [Pyprland](https://github.com/hyprland-community/pyprland)     | Scratchpad terminal, slides in from the top on Super+`                   |
| [Dunst](https://dunst-project.org)                             | Notification daemon                                                      |
| [SwayNC](https://github.com/ErikReider/SwayNotificationCenter) | Notification center (configured, inactive by default)                    |
| [wlogout](https://github.com/ArtsyMacaw/wlogout)               | Logout / shutdown menu                                                   |
| [SDDM](https://github.com/sddm/sddm)                           | Display manager, Catppuccin Macchiato Blue theme                         |

**Terminals and shell**

| Tool                                                               | Role                                                                      |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| [Ghostty](https://ghostty.org)                                     | Main terminal — Rec Mono Casual, 12pt, slashed zero, adjusted line height |
| [Kitty](https://sw.kovidgoyal.net/kitty/)                          | Secondary terminal — Fira Code, same palette                              |
| [Zellij](https://zellij.dev)                                       | Terminal multiplexer, compact layout, vim keybinds, tmux-style prefix     |
| [Zsh](https://zsh.sourceforge.io/) + [Oh My Zsh](https://ohmyz.sh) | Shell, Powerlevel10k prompt, autosuggestions, fast-syntax-highlighting    |

**Editors**

| Tool                                     | Role                                                             |
| ---------------------------------------- | ---------------------------------------------------------------- |
| [Neovim](https://neovim.io)              | LazyVim base + 27 plugins                                        |
| [VS Code](https://code.visualstudio.com) | Settings only — Rec Mono Casual, Prettier, Tailwind IntelliSense |

**CLI tools**

`fzf`, `bat`, `eza`, `zoxide`, `atuin` (SQLite shell history), `fd`, `ripgrep`, `jq`, `delta` (git diffs), `lazygit`, `btop`, `fastfetch`

**Media and files**

[mpv](https://mpv.io) for video/audio (Vulkan, PipeWire, Rec Mono Linear subtitles), `grim` + `slurp` + `satty` for screenshots, `cliphist` for clipboard history, `playerctl` + `pamixer` for media keys, [Yazi](https://yazi-rs.github.io/) as terminal file manager, [Thunar](https://docs.xfce.org/xfce/thunar/start) and Dolphin for GUI.

---

## Theme

The palette is Catppuccin Macchiato everywhere: bar, terminals, editor, notifications, lock screen, GRUB, SDDM, Rofi, wlogout. The hex values are defined once per config and referenced by name rather than repeated inline.

One inconsistency to know about: Dunst uses Catppuccin **Mocha** (`#1e1e2e` base) instead of Macchiato (`#24273a`). The difference is subtle but it's there if you look.

Font is **Rec Mono Casual** for editing and terminals, **Rec Mono Linear** where the UI needs something more neutral (Waybar, Rofi, notifications, lock screen, mpv subtitles). Rec Mono isn't in the repos — grab it from [recursive.design](https://www.recursive.design/) or the [GitHub releases](https://github.com/arrowtype/recursive/releases), drop the `.ttf` files in `~/.local/share/fonts/`, then run `fc-cache -fv`.

---

## Neovim plugins

LazyVim base with these additions:

| Plugin                                                                                                                           | What it does                                                                      |
| -------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| [catppuccin/nvim](https://github.com/catppuccin/nvim)                                                                            | Colorscheme — Macchiato, with undercurl diagnostics and custom line number colors |
| [typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim)                                                         | Faster TypeScript LSP, organize imports, rename file + update all imports         |
| [copilot.lua](https://github.com/zbirenbaum/copilot.lua) + [CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) | Inline suggestions (Alt+L to accept) + chat panel                                 |
| [kulala.nvim](https://github.com/mistweaverco/kulala.nvim)                                                                       | REST client for `.http` files — runs requests, shows response in a split          |
| [nvim-colorizer.lua](https://github.com/catgoose/nvim-colorizer.lua)                                                             | Inline color swatches for hex, rgb, oklch, Tailwind class names                   |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)                                                                | Highlighted TODO/FIXME/HACK/NOTE with Macchiato colors and Telescope search       |
| [vim-visual-multi](https://github.com/mg979/vim-visual-multi)                                                                    | Multiple cursors — Ctrl+D like VS Code, Alt+J/K for up/down                       |
| [nvim-spider](https://github.com/chrisgrieser/nvim-spider)                                                                       | camelCase-aware `w`, `e`, `b` motions                                             |
| [yanky.nvim](https://github.com/gbprod/yanky.nvim)                                                                               | Yank ring with persistent history, highlighted yank feedback                      |
| [noice.nvim](https://github.com/folke/noice.nvim)                                                                                | Floating cmdline palette, LSP hover border, signature help, notification routing  |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                                                                     | Bubbles statusline — mode, branch, diff, LSP document symbols, diagnostics        |
| [precognition.nvim](https://github.com/tris203/precognition.nvim)                                                                | Inline motion hints (`w`, `e`, `b`, `$`, `%`...) while editing                    |
| [guess-indent.nvim](https://github.com/nmac427/guess-indent.nvim)                                                                | Detects tabs vs spaces per buffer, overrides editorconfig                         |
| [wakatime](https://github.com/wakatime/vim-wakatime)                                                                             | Coding time tracking                                                              |

The `<Tab>` key is configured as a supertab: it expands snippets, jumps between fields, confirms completions, or opens the popup depending on context. No separate mappings for each case.

ESLint handles formatting in JS/TS buffers. tsserver is active but its formatting provider is disabled to avoid conflicts.

---

## Structure

```
dots-files/
├── assets/wallpaper/         # Wallpapers
├── atuin/                    # Shell history (config.toml)
├── btop/                     # System monitor (btop.conf)
├── dunst/                    # Notification daemon
├── fastfetch/                # System info display (fastfetch-config.jsonc)
├── ghostty/                  # Main terminal (config.ghostty)
├── git/                      # .gitconfig
├── grub/                     # GRUB config · 40_custom · theme script
├── hyprland/                 # hyprland.conf · hyprlock.conf · hyprpaper.conf · hypridle.conf
│   └── scripts/              # color-picker.sh · screenshot.sh · rofi-search.sh
├── imv/                      # Image viewer (config)
├── kitty/                    # Secondary terminal (kitty.conf)
├── lazygit/                  # Git TUI (config.yml)
├── mpv/                      # Media player (mpv.conf · input.conf)
├── nvim/lua/                 # config/ (options, keymaps, autocmds) · plugins/
├── opencode/                 # OpenCode AI coding assistant
├── pyprland/                 # Scratchpad extension (pyprland.toml)
├── rofi/                     # Launcher theme (config.rasi)
├── sddm/                     # Display manager (sddm.conf · install-sddm-theme.sh)
├── swaync/                   # Notification center (config.json · style.css)
├── vs code/                  # settings.json
├── waybar/                   # config.jsonc · style.css
├── wlogout/                  # Logout menu (style.css · layout)
├── xorg/                     # 00-keyboard.conf — AZERTY layout for XWayland
├── yazi/                     # Terminal file manager (yazi.toml · keymap.toml · theme.toml)
├── zellij/                   # Multiplexer (config.kdl · catppuccin-macchiato.kdl)
├── zsh/                      # .zshrc
├── install.sh                # Selective installer (25 components)
└── packages.txt              # Full package reference
```

---

## Installation

### With the installer

```bash
git clone https://github.com/SouleymaneSy7/dots-files.git ~/dots-files
cd ~/dots-files
./install.sh
```

The script installs packages via pacman and yay, backs up existing configs to `~/.config/dots-backup-<timestamp>`, copies files, and enables systemd services. The menu lets you toggle components individually.

### Manual

```bash
git clone https://github.com/SouleymaneSy7/dots-files.git ~/dots-files

# Back up first
cp -r ~/.config/hypr ~/.config/hypr.bak
cp -r ~/.config/waybar ~/.config/waybar.bak
# repeat for anything you want to keep

# Copy configs
cp -r ~/dots-files/hyprland/*  ~/.config/hypr/
cp -r ~/dots-files/waybar/*    ~/.config/waybar/
cp -r ~/dots-files/dunst/*     ~/.config/dunst/
cp -r ~/dots-files/rofi/*      ~/.config/rofi/
cp -r ~/dots-files/ghostty/*   ~/.config/ghostty/
cp -r ~/dots-files/kitty/*     ~/.config/kitty/
cp -r ~/dots-files/pyprland/*  ~/.config/pyprland/
cp -r ~/dots-files/btop/*      ~/.config/btop/
cp -r ~/dots-files/swaync/*    ~/.config/swaync/
cp -r ~/dots-files/nvim/*      ~/.config/nvim/
cp    ~/dots-files/zsh/.zshrc  ~/.zshrc
cp    ~/dots-files/git/.gitconfig ~/.gitconfig

# Make scripts executable
chmod +x ~/.config/hypr/scripts/*.sh

# Reload
hyprctl reload
```

---

## Guides

| Guide                                                             | Covers                                                  |
| ----------------------------------------------------------------- | ------------------------------------------------------- |
| [Arch Linux Installation](./ARCH_LINUX_INSTALLATION.md)           | Base system, MBR/Legacy BIOS, dual-boot with Windows    |
| [Hyprland Installation](./HYPRLAND_INSTALLATION_GUIDE.md)        | Full stack setup from a fresh Arch install              |
| [Swap File Creation](./SWAP_FILE_CREATION.md)                     | Creating and persisting a swap file                     |
| [Uninstall Linux on Dual Boot](./UNINSTALL_LINUX_ON_DUAL_BOOT.md) | Restoring the Windows bootloader, reclaiming partitions |
| [Useful Resources](./USEFUL_RESOURCES.md)                         | Docs and wikis for every tool in the stack              |

---

## Author

[Souleymane Sy](https://github.com/SouleymaneSy7) — frontend developer, available for freelance.
