# ═══════════════════════════════════════════════════════════
# ZSH - Shell Configuration (.zshrc)
# ═══════════════════════════════════════════════════════════
#
# Description:
#   Main configuration file for Zsh with Oh My Zsh. Configures
#   the theme (Powerlevel10k), plugins, aliases, and runtime
#   environments for Node.js (NVM), pnpm, Bun, and CLI tools.
#
# Location:
#   ~/.zshrc
#
# Installation:
#   sudo pacman -S zsh && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#
# Usage:
#   source ~/.zshrc   (apply changes in current session)
#   chsh -s /bin/zsh  (set as default shell)
#
# Reload:
#   source ~/.zshrc
#   Or open a new terminal session
#
# Theme:
#   Powerlevel10k (Catppuccin Macchiato-style prompt)
#
# Dependencies:
#   - oh-my-zsh              (framework)
#   - powerlevel10k          (prompt theme)
#   - zsh-syntax-highlighting  (plugin)
#   - zsh-autosuggestions       (plugin)
#
# See also:
#   fastfetch/fastfetch-config.jsonc  (system info on shell start)
#   ~/.p10k.zsh                       (Powerlevel10k config)
#
# Documentation:
#   https://zsh.sourceforge.io/Doc/

# ─── Powerlevel10k Instant Prompt ──────────────────────────
# Must stay near the top of .zshrc to enable instant prompt.
# Any code that requires console input (password prompts, y/n) must
# appear ABOVE this block.

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─── Oh My Zsh Installation Path ───────────────────────────
# Points to the Oh My Zsh framework directory.
# Required before sourcing oh-my-zsh.sh below.
export ZSH="$HOME/.oh-my-zsh"

# ─── Theme ─────────────────────────────────────────────────

# Sets the Oh My Zsh prompt theme.
# The prompt appearance is configured in ~/.p10k.zsh (run `p10k configure`).
# Available themes: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#
# ZSH_THEME="agnoster"                     # Powerline-style minimal prompt
# ZSH_THEME="alanpeabody"                  # Active theme
ZSH_THEME="powerlevel10k/powerlevel10k"    # Feature-rich async prompt

# ─── Auto-Update Behavior ──────────────────────────────────
# Automatically update Oh My Zsh in the background without prompting.
# Alternatives:
# zstyle ':omz:update' mode disabled   # Never update automatically
# zstyle ':omz:update' mode reminder   # Notify when an update is available
zstyle ':omz:update' mode auto

# ─── Plugins ───────────────────────────────────────────────
# Plugins are loaded from $ZSH/plugins/ (built-in) or
# $ZSH_CUSTOM/plugins/ (custom/third-party).
# Keep this list lean — too many plugins slow down shell startup.
#
# ⚠️  ORDER MATTERS: fast-syntax-highlighting MUST be the LAST plugin.
#     zsh-autocomplete should come after zsh-autosuggestions.
plugins=(
  git                      # Git aliases: g, gst, gco, gp, etc.
  sudo                     # Press ESC twice to prepend sudo to the last command
  history                  # History shortcuts: h, hs, hsi
  copyfile                 # Copy a file's contents to the clipboard
  web-search               # Search the web from the terminal: google, bing, etc.
  dirhistory               # Navigate directory history with Alt+Left / Alt+Right
  zsh-autosuggestions      # Fish-style inline suggestions from shell history
  zsh-autocomplete         # Real-time completion menu as you type
  fast-syntax-highlighting # Syntax highlighting for commands as you type
)

# Load Oh My Zsh and all configured plugins.
source $ZSH/oh-my-zsh.sh

# ─── Default Editor ────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

# ─── Language Environment ──────────────────────────────────
# Sets the system locale to French UTF-8.
# Affects date formats, number formatting, and message language.
export LANG=fr_FR.UTF-8

# ─── Core Aliases ──────────────────────────────────────────
alias svim='sudo -E nvim'
alias vim=nvim

alias pn=pnpm
alias bn=bun

alias search=web_search

# ─── eza: better ls ────────────────────────────────────────
# eza replaces ls with Nerd Font icons, colors, and inline Git status.
# Installation: sudo pacman -S eza
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lah --icons --git --group-directories-first'
  alias la='eza -a --icons --group-directories-first'
  alias lt='eza --tree --icons --level=2 --group-directories-first'
  alias lt3='eza --tree --icons --level=3 --group-directories-first'
fi

# ─── bat: better cat ───────────────────────────────────────
# bat adds syntax highlighting, line numbers, and Git integration to cat.
# Also replaces the man pager for readable manual pages.
# Installation: sudo pacman -S bat
if command -v bat &>/dev/null; then
  alias cat='bat --style=auto'

  # Use bat as the pager for man pages.
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFF_OPT="-c"

  # Theme for bat output — matches the rest of the project palette.
  export BAT_THEME="Catppuccin Macchiato"
fi

# ─── zoxide: smarter cd ────────────────────────────────────
# zoxide learns directories you visit and lets you jump back with
# a short fragment: z dots → ~/dots-files, z conf → ~/.config
# Installation: sudo pacman -S zoxide
if command -v zoxide &>/dev/null; then
  # Initialize zoxide. z replaces cd, zi opens an interactive fzf picker.
  eval "$(zoxide init zsh --cmd z)"

  # Keep the standard cd available in parallel with z.
  alias cd='z'
fi

# ─── fzf: fuzzy finder ─────────────────────────────────────
# fzf enhances Ctrl+R (history), Ctrl+T (files), and Alt+C (directories).
# Installation: sudo pacman -S fzf fd ripgrep
if command -v fzf &>/dev/null; then
  # Load fzf shell integrations (keybindings + completion).
  source <(fzf --zsh)

  # Use fd instead of find: faster, respects .gitignore.
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'

  # Visual options: Catppuccin Macchiato colors with bat file preview.
  export FZF_DEFAULT_OPTS="
    --height 40%
    --layout=reverse
    --border=rounded
    --prompt='  '
    --pointer=' '
    --marker='● '
    --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
    --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
    --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
    --color=border:#494d64
    --preview 'bat --color=always --style=numbers --line-range=:80 {}'
    --preview-window=right:50%:hidden
    --bind='ctrl-/:toggle-preview'
  "

  # Ctrl+T: show a bat preview for the selected file.
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"

  # Alt+C: show an eza tree preview for the selected directory.
  export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons {}'"
fi

# ─── yazi: terminal file manager ───────────────────────────
# Shell function that opens yazi and changes the working directory
# to wherever yazi was when it was closed.
# Installation: sudo pacman -S yazi ffmpegthumbnailer poppler unarj
function y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  command yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  command rm -f -- "$tmp"
}

# ─── atuin: advanced shell history ─────────────────────────
# Replaces Ctrl+R with a searchable SQLite database of every command.
# Filters by directory, exit code, or date. Optionally synced to a server.
# Installation: yay -S atuin
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi

# ─── Node Version Manager (NVM) ────────────────────────────
# NVM allows switching between multiple Node.js versions.
# The first line loads nvm itself; the second enables bash-compatible
# tab completion for nvm commands.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ─── pnpm ──────────────────────────────────────────────────
# pnpm is a fast, disk-efficient Node.js package manager.
# Adds the pnpm global bin directory to PATH if not already present.
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ─── Bun ───────────────────────────────────────────────────
# Bun is an all-in-one JavaScript runtime and package manager.
# Sources shell completions and adds the Bun binary directory to PATH.
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ─── SSH Agent ───────────────────────────────────
# Start ssh-agent only once and add the primary key.
# The guard prevents spawning a new agent on every terminal session,
# which would leave orphaned agent processes over time.
if [ -z "$SSH_AUTH_SOCK" ]; then
  if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)" > /dev/null
  fi
fi

if [ -f ~/.ssh/id_ed25519 ]; then
  ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# ─── Homebrew ──────────────────────────────────
# Linuxbrew (Homebrew on Linux) — package manager installed in /home/linuxbrew.
# Sources the Homebrew shell environment to add its bin directory to PATH.
if command -v brew &>/dev/null; then
  eval "$(brew shellenv)"
fi

# ─── Opencode ──────────────────────────────────
# AI coding assistant CLI. Adds the Opencode binary directory to PATH.
export PATH=$HOME/.opencode/bin:$PATH

# ─── Local Binaries ────────────────────────────
# Personal scripts (e.g. ~/.local/bin/skillfile).
export PATH="$HOME/.local/bin:$PATH"

# ─── Powerlevel10k Prompt ──────────────────────────────────
# Source the p10k prompt configuration if it exists.
# To reconfigure interactively, run: p10k configure
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
