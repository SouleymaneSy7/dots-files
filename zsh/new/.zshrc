# ═══════════════════════════════════════════════════════════
# ZSH - Shell Configuration (.zshrc)
# ═══════════════════════════════════════════════════════════
#
# Main configuration file for Zsh with Oh My Zsh.
# Configures the theme, plugins, aliases, and runtime environments
# for Node.js (NVM), pnpm, and Bun.

# ─── Powerlevel10k Instant Prompt ──────────────────────────
# Must stay near the top of .zshrc to enable instant prompt.
# Caches the prompt so it renders immediately on shell startup
# without waiting for slow initialization scripts to complete.
# Any code requiring console input (password prompts, y/n) must
# appear ABOVE this block.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─── Oh My Zsh Installation Path ───────────────────────────
# Points to the Oh My Zsh framework directory.
# Required before sourcing oh-my-zsh.sh below.
export ZSH="$HOME/.oh-my-zsh"

# ─── Theme ─────────────────────────────────────────────────
# Sets the Oh My Zsh prompt theme.
# Available themes: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"  # Feature-rich async prompt
# ZSH_THEME="agnoster"                     # Powerline-style minimal prompt
ZSH_THEME="alanpeabody"                    # Active theme

# ─── Auto-Update Behavior ──────────────────────────────────
# Automatically update Oh My Zsh in the background without prompting.
# Alternatives:
#   zstyle ':omz:update' mode disabled   # Never update automatically
#   zstyle ':omz:update' mode reminder   # Notify when an update is available
zstyle ':omz:update' mode auto

# ─── Plugins ───────────────────────────────────────────────
# Plugins are loaded from $ZSH/plugins/ (built-in) or
# $ZSH_CUSTOM/plugins/ (custom/third-party).
# Keep this list lean — too many plugins slow down shell startup.
plugins=(
  git                     # Git aliases and branch info (g, gst, gco, etc.)
  sudo                    # Press ESC twice to prefix the last command with sudo
  history                 # History search shortcuts (h, hs, hsi)
  copyfile                # Copy a file's contents to the clipboard
  web-search              # Search the web from the terminal (google, bing, etc.)
  dirhistory              # Navigate directory history with Alt+Left/Right
  zsh-autocomplete        # Real-time completion menu as you type
  zsh-autosuggestions     # Fish-style inline command suggestions from history
  zsh-syntax-highlighting # Syntax highlighting for commands as you type
  fast-syntax-highlighting # Faster alternative syntax highlighter
)

# Load Oh My Zsh and all configured plugins.
source $ZSH/oh-my-zsh.sh

# ─── Language Environment ──────────────────────────────────
# Sets the system locale to French UTF-8.
# Affects date formats, number formatting, and message language.
export LANG=fr_FR.UTF-8

# ─── Aliases ───────────────────────────────────────────────

# Use Neovim as the default vi/vim command.
alias vim=nvim

# Shorthand for pnpm package manager.
alias pn=pnpm

# ─── Node Version Manager (NVM) ────────────────────────────
# NVM allows switching between multiple Node.js versions.
# The first line loads nvm itself; the second enables bash-compatible
# tab completion for nvm commands.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load nvm bash completion

# ─── pnpm ──────────────────────────────────────────────────
# pnpm is a fast, disk-efficient Node.js package manager.
# Adds the pnpm global bin directory to PATH if not already present.
export PNPM_HOME="/home/Souleymane_Sy/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;                          # Already in PATH, skip
  *) export PATH="$PNPM_HOME:$PATH" ;;          # Prepend pnpm bin to PATH
esac

# ─── Bun ───────────────────────────────────────────────────
# Bun is an all-in-one JavaScript runtime and package manager.
# Sources shell completions and adds the Bun binary directory to PATH.
[ -s "/home/Souleymane_Sy/.bun/_bun" ] && source "/home/Souleymane_Sy/.bun/_bun" # Load Bun completions

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH" # Add Bun binary to PATH

# ─── Powerlevel10k Prompt ──────────────────────────────────
# Sources the p10k prompt configuration if it exists.
# To reconfigure the prompt interactively, run: p10k configure
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
