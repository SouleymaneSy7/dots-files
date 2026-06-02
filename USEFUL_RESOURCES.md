# Useful Resources for Arch Linux & Hyprland

Curated references for every tool in this dotfiles repository.

---

## Arch Linux Installation

- [Dual Booting Arch Linux and Windows 10/11](https://gist.github.com/uosyph/bb7db7606c4916535081ae7b0f6bff2d) — Comprehensive dual-boot setup guide
- [Arch Linux on Legacy BIOS/MBR](https://gist.github.com/xbns/cb8d0f9734a99c19c2503d8439f79e71) — Step-by-step for older BIOS systems
- [Dual Boot Windows & Arch Linux](https://github.com/daneelsan/Dual_boot_Windows_Archlinux) — Configuration walkthrough
- [Swap File and Hibernation on Arch Linux](https://me.jaytaala.com/use-a-swap-file-and-enable-hibernation-on-arch-linux-including-on-a-luks-root-partition/) — Includes LUKS-encrypted partitions
- [Arch Wiki — Installation Guide](https://wiki.archlinux.org/title/Installation_guide) — The official reference

---

## Hyprland Ecosystem

| Tool             | Documentation                                                                                     | Purpose                             |
| ---------------- | ------------------------------------------------------------------------------------------------- | ----------------------------------- |
| Hyprland         | [wiki.hyprland.org](https://wiki.hyprland.org/)                                                   | Wayland compositor (core)           |
| Hyprlock         | [wiki.hyprland.org/Hypr-Ecosystem/hyprlock](https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/)   | Screen locker                       |
| Hypridle         | [wiki.hyprland.org/Hypr-Ecosystem/hypridle](https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/)   | Idle management daemon              |
| Hyprpaper        | [wiki.hyprland.org/Hypr-Ecosystem/hyprpaper](https://wiki.hyprland.org/Hypr-Ecosystem/hyprpaper/) | Wallpaper daemon                    |
| Pyprland         | [hyprland-community.github.io/pyprland](https://hyprland-community.github.io/pyprland/)           | Scratch terminals and extensions    |
| Hyprland Plugins | [github.com/hyprwm/hyprland-plugins](https://github.com/hyprwm/hyprland-plugins)                  | Hyprexpo and other official plugins |

---

## Status Bar & Notifications

| Tool   | Documentation                                                                                        | Purpose                                             |
| ------ | ---------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| Waybar | [github.com/Alexays/Waybar/wiki](https://github.com/Alexays/Waybar/wiki)                             | Status bar (workspaces, clock, system stats, media) |
| Dunst  | [dunst-project.org](https://dunst-project.org/documentation/)                                        | Notification daemon (active)                        |
| Swaync | [github.com/ErikReider/SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter) | Alternative notification center                     |

---

## Application Launcher & Powermenu

| Tool    | Documentation                                                              | Purpose                               |
| ------- | -------------------------------------------------------------------------- | ------------------------------------- |
| Rofi    | [github.com/davatorium/rofi/wiki](https://github.com/davatorium/rofi/wiki) | App launcher, runner, window switcher |
| Wlogout | [github.com/ArtsyMacaw/wlogout](https://github.com/ArtsyMacaw/wlogout)     | Logout / power menu overlay           |

---

## Terminals

| Tool    | Documentation                                                    | Purpose                                 |
| ------- | ---------------------------------------------------------------- | --------------------------------------- |
| Ghostty | [ghostty.org/docs](https://ghostty.org/docs/configuration)       | Primary terminal emulator               |
| Kitty   | [sw.kovidgoyal.net/kitty](https://sw.kovidgoyal.net/kitty/conf/) | Secondary terminal emulator             |
| Zellij  | [zellij.dev/documentation](https://zellij.dev/documentation/)    | Terminal multiplexer (tmux alternative) |

---

## Shell & CLI Experience

### Zsh & Oh My Zsh

- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) — Framework and plugin directory
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) — Prompt theme used in this project
- [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) — Faster syntax highlighting
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) — Fish-style inline suggestions
- [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete) — Real-time completion menu

### CLI Tools

| Tool      | Documentation                                                                    | Purpose                                               |
| --------- | -------------------------------------------------------------------------------- | ----------------------------------------------------- |
| eza       | [github.com/eza-community/eza](https://github.com/eza-community/eza)             | Better `ls` with icons and Git status                 |
| bat       | [github.com/sharkdp/bat](https://github.com/sharkdp/bat)                         | Better `cat` with syntax highlighting                 |
| fzf       | [github.com/junegunn/fzf](https://github.com/junegunn/fzf)                       | Universal fuzzy finder (Ctrl+R, Ctrl+T, Alt+C)        |
| zoxide    | [github.com/ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide)           | Smarter `cd` that learns your habits                  |
| delta     | [dandavison.github.io/delta](https://dandavison.github.io/delta/)                | Syntax-highlighted `git diff` pager                   |
| atuin     | [atuin.sh](https://atuin.sh)                                                     | Shell history with SQLite search                      |
| yazi      | [yazi-rs.github.io](https://yazi-rs.github.io/docs/)                             | Terminal file manager (Rust)                          |
| fastfetch | [github.com/fastfetch-cli/fastfetch](https://github.com/fastfetch-cli/fastfetch) | System info on shell start                            |
| btop      | [github.com/aristocratos/btop](https://github.com/aristocratos/btop)             | Interactive system monitor (CPU, RAM, disks, network) |
| lazygit   | [github.com/jesseduffield/lazygit](https://github.com/jesseduffield/lazygit)     | TUI Git client                                        |

---

## Git

- [Git Reference](https://git-scm.com/docs) — Official documentation
- [Delta](https://dandavison.github.io/delta/) — Diff pager configured in `.gitconfig`

---

## Media & Utilities

| Tool          | Documentation                                                                                                   | Purpose                                          |
| ------------- | --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| mpv           | [mpv.io/manual](https://mpv.io/manual/stable/)                                                                  | Video/audio player (Yazi integration)            |
| imv           | [github.com/eXeC64/imv](https://github.com/eXeC64/imv)                                                          | Image viewer for Wayland                         |
| cliphist      | [github.com/sentriz/cliphist](https://github.com/sentriz/cliphist)                                              | Clipboard manager (Wayland wl-clipboard history) |
| playerctl     | [github.com/altdesktop/playerctl](https://github.com/altdesktop/playerctl)                                      | MPRIS media player CLI controller                |
| pamixer       | [github.com/cdemoulins/pamixer](https://github.com/cdemoulins/pamixer)                                          | PulseAudio volume control CLI                    |
| pavucontrol   | [freedesktop.org/software/pulseaudio/pavucontrol](https://www.freedesktop.org/software/pulseaudio/pavucontrol/) | PulseAudio volume mixer GUI                      |
| brightnessctl | [github.com/Hummer12007/brightnessctl](https://github.com/Hummer12007/brightnessctl)                            | Backlight control CLI                            |
| nmtui         | NetworkManager TUI — Built-in                                                                                   | WiFi and network management                      |

---

## Catppuccin Theme

All tools in this project use the **Macchiato** variant.

- [Catppuccin Website](https://catppuccin.com/) — Palette reference and all ports
- [Catppuccin Palette](https://catppuccin.com/palette) — Exact hex values for every variant
- [Catppuccin for Hyprland](https://github.com/catppuccin/hyprland)
- [Catppuccin for Waybar](https://github.com/catppuccin/waybar)
- [Catppuccin for Neovim](https://github.com/catppuccin/nvim)
- [Catppuccin for bat](https://github.com/catppuccin/bat)
- [Catppuccin for btop](https://github.com/catppuccin/btop)
- [Catppuccin for delta](https://github.com/catppuccin/delta)
- [Catppuccin for Ghostty](https://github.com/catppuccin/ghostty)
- [Catppuccin for Yazi](https://github.com/catppuccin/yazi)
- [Catppuccin for SDDM](https://github.com/catppuccin/sddm)
- [Catppuccin for GRUB](https://github.com/catppuccin/grub)

---

## Neovim (LazyVim)

- [LazyVim Official Website](https://www.lazyvim.org/)
- [LazyVim Installation Guide](https://www.lazyvim.org/installation)
- [LazyVim Configuration](https://www.lazyvim.org/configuration)
- [LazyVim for Ambitious Developers](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-1/) — In-depth course
- [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim) — Curated plugin list

### Plugins in This Project

| Plugin                  | Documentation                                                                                  | Purpose                            |
| ----------------------- | ---------------------------------------------------------------------------------------------- | ---------------------------------- |
| catppuccin/nvim         | [github.com/catppuccin/nvim](https://github.com/catppuccin/nvim)                               | Colorscheme (Macchiato)            |
| typescript-tools.nvim   | [github.com/pmizio/typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim)     | Better TypeScript LSP              |
| kulala.nvim             | [github.com/mistweaverco/kulala.nvim](https://github.com/mistweaverco/kulala.nvim)             | REST client for `.http` files      |
| todo-comments.nvim      | [github.com/folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)             | TODO/FIXME/HACK highlighting       |
| nvim-colorizer.lua      | [github.com/catgoose/nvim-colorizer.lua](https://github.com/catgoose/nvim-colorizer.lua)       | Inline color previews              |
| nvim-ts-autotag         | [github.com/windwp/nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)                 | Auto-close HTML/JSX tags           |
| yanky.nvim              | [github.com/gbprod/yanky.nvim](https://github.com/gbprod/yanky.nvim)                           | Yank history and advanced paste    |
| nvim-spider             | [github.com/chrisgrieser/nvim-spider](https://github.com/chrisgrieser/nvim-spider)             | camelCase-aware word motions       |
| precognition.nvim       | [github.com/tris203/precognition.nvim](https://github.com/tris203/precognition.nvim)           | Keystroke hint overlay             |
| vim-visual-multi        | [github.com/mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi)                 | Multiple cursors                   |
| copilot.lua             | [github.com/zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua)                 | GitHub Copilot inline suggestions  |
| CopilotChat.nvim        | [github.com/CopilotC-Nvim/CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim) | GitHub Copilot chat interface      |
| guess-indent.nvim       | [github.com/nmac427/guess-indent.nvim](https://github.com/nmac427/guess-indent.nvim)           | Automatic indentation detection    |
| eslint (nvim-lspconfig) | [github.com/neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                   | ESLint LSP integration             |
| lualine.nvim            | [github.com/nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)           | Statusline with bubbles layout     |
| markdown-preview.nvim   | [github.com/iamcco/markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)     | Markdown preview in browser        |
| mini-pairs.nvim         | [github.com/nvim-neorocks/mini-pairs.nvim](https://github.com/nvim-neorocks/mini-pairs.nvim)   | Auto-pair brackets and quotes      |
| noice.nvim              | [github.com/folke/noice.nvim](https://github.com/folke/noice.nvim)                             | Modern cmdline and message UI      |
| nvim-cmp + LuaSnip      | [github.com/hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                             | Completion engine with supertab    |
| snacks.nvim             | [github.com/folke/snacks.nvim](https://github.com/folke/snacks.nvim)                           | File explorer, notifier, dashboard |
| wakatime                | [github.com/wakatime/vim-wakatime](https://github.com/wakatime/vim-wakatime)                   | Automatic coding activity tracker  |
| nvim-web-devicons       | [github.com/nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)       | Filetype icons for UI plugins      |
| which-key.nvim          | [github.com/folke/which-key.nvim](https://github.com/folke/which-key.nvim)                     | Keybinding discovery popup         |

---

## Boot & Display Manager

| Tool | Documentation                                                      | Purpose                                |
| ---- | ------------------------------------------------------------------ | -------------------------------------- |
| GRUB | [gnu.org/software/grub](https://www.gnu.org/software/grub/manual/) | Bootloader                             |
| SDDM | [github.com/sddm/sddm](https://github.com/sddm/sddm)               | Display manager (Wayland login screen) |

---

## Video Resources

### Arch Linux Installation

- [Arch Linux Full Install on MBR/BIOS](https://www.youtube.com/watch?v=4wbMcL1Optc) — EF Linux Made Simple: complete walkthrough

### Hyprland

- Search YouTube for **"Hyprland rice 2026"** or **"Hyprland configuration"** for recent setup videos

### LazyVim

- [LazyVim Installation Tutorial](https://www.youtube.com/watch?v=N93cTbtLCIM)

### CLI Tools

- [fzf tips and tricks](https://www.youtube.com/watch?v=qgG5Jhi_Els) — Advanced fzf integrations
- Search YouTube for **"yazi file manager"** for workflow demonstrations

---

## Quick Reference — Official Docs

| Tool      | Documentation URL                                    |
| --------- | ---------------------------------------------------- |
| Hyprland  | https://wiki.hyprland.org/                           |
| Waybar    | https://github.com/Alexays/Waybar/wiki               |
| Dunst     | https://dunst-project.org/documentation/             |
| Swaync    | https://github.com/ErikReider/SwayNotificationCenter |
| Rofi      | https://github.com/davatorium/rofi/wiki              |
| Wlogout   | https://github.com/ArtsyMacaw/wlogout                |
| Ghostty   | https://ghostty.org/docs/configuration               |
| Kitty     | https://sw.kovidgoyal.net/kitty/conf/                |
| Zellij    | https://zellij.dev/documentation/                    |
| Hyprlock  | https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/   |
| Hypridle  | https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/   |
| Hyprpaper | https://wiki.hyprland.org/Hypr-Ecosystem/hyprpaper/  |
| Pyprland  | https://hyprland-community.github.io/pyprland/       |
| Yazi      | https://yazi-rs.github.io/docs/                      |
| mpv       | https://mpv.io/manual/stable/                        |
| imv       | https://github.com/eXeC64/imv                        |
| lazygit   | https://github.com/jesseduffield/lazygit             |
| LazyVim   | https://www.lazyvim.org/                             |
| Neovim    | https://neovim.io/doc/                               |
| Arch Wiki | https://wiki.archlinux.org/                          |
