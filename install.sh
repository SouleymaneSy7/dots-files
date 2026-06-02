#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# INSTALL - Selective dots-files Installer
# ═══════════════════════════════════════════════════════════
#
# Author: Souleymane Sy
#
# Description:
# Interactive installer for Arch Linux + Hyprland + Catppuccin
# Macchiato dotfiles. Allows you to precisely choose which
# components to install: packages, configurations, services.
# Each component is independent.
#
# Usage:
# ./install.sh
#
# Prerequisites:
# - Arch Linux (base system installed)
# - Internet connection
# - Non-root user account with sudo privileges
#
# What this script does for each selected component:
# 1. Installs packages via pacman and/or yay
# 2. Creates a backup of existing configuration
# 3. Copies configuration files from this repository
# 4. Enables systemd services if necessary
#
# Documentation:
# HYPERLAND_INSTALLATION_GUIDE.md
# ═══════════════════════════════════════════════════════════
# CONSTANTS
# ═══════════════════════════════════════════════════════════
# Root directory of the dots-files repository, resolved from
# the script's own location — works regardless of current directory.
readonly DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Dated log file for each run. Useful for debugging
# post-installation errors without having to rerun everything.
readonly LOG_FILE="/tmp/dots-install-$(date +%Y%m%d-%H%M%S).log"
# Backup directory for replaced configurations.
readonly BACKUP_DIR="${HOME}/.config/dots-backup-$(date +%Y%m%d%H%M%S)"

# ═══════════════════════════════════════════════════════════
# COLORS (ANSI standard — compatible with any terminal)
# ═══════════════════════════════════════════════════════════
readonly BLUE='\033[34m'
readonly MAUVE='\033[35m'
readonly GREEN='\033[32m'
readonly RED='\033[31m'
readonly YELLOW='\033[33m'
readonly CYAN='\033[36m'
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly RESET='\033[0m'

# ═══════════════════════════════════════════════════════════
# DISPLAY HELPERS
# ═══════════════════════════════════════════════════════════
# Each helper also logs to the log file for easier debugging.
info() {
	printf "${BLUE} →${RESET} %s\n" "$*"
	echo "[INFO] $*" >>"$LOG_FILE"
}
success() {
	printf "${GREEN} ✓${RESET} %s\n" "$*"
	echo "[SUCCESS] $*" >>"$LOG_FILE"
}
error() {
	printf "${RED} ✗${RESET} %s\n" "$*" >&2
	echo "[ERROR] $*" >>"$LOG_FILE"
}
warn() {
	printf "${YELLOW} !${RESET} %s\n" "$*"
	echo "[WARN] $*" >>"$LOG_FILE"
}
step() {
	printf "\n${BOLD}${MAUVE}── %s${RESET}\n" "$*"
	echo "[STEP] $*" >>"$LOG_FILE"
}
dim() { printf "${DIM} %s${RESET}\n" "$*"; }

# ═══════════════════════════════════════════════════════════
# COMPONENT DEFINITION
# ═══════════════════════════════════════════════════════════
# Each parallel array shares the same index N for component N.
# KEYS: internal identifier used by install_* functions
# DESCS: text displayed in the menu
# GROUPS: visual category for the menu
readonly -a COMP_KEYS=(
	"core"
	"hyprland"
	"pyprland"
	"waybar"
	"rofi"
	"ghostty"
	"kitty"
	"zsh"
	"neovim"
	"vscode"
	"git"
	"thunar"
	"yazi"
	"mpv"
	"audio"
	"screenshot"
	"clipboard"
	"dunst"
	"swaync"
	"system"
	"wlogout"
	"zellij"
	"fonts"
	"sddm"
	"brave"
)
readonly -a COMP_DESCS=(
	"Base tools (base-devel, polkit, xdg-utils)"
	"Hyprland + hyprlock + hyprpaper + hypridle"
	"Pyprland — scratchpad terminal"
	"Waybar — status bar"
	"Rofi — application launcher"
	"Ghostty — main terminal"
	"Kitty — secondary terminal"
	"Zsh + Oh My Zsh + plugins + Powerlevel10k"
	"Neovim + LazyVim"
	"VS Code — user settings"
	"Git + git-delta + lazygit + .gitconfig"
	"Thunar + Yazi — file managers"
	"Yazi — terminal file manager"
	"mpv — media player"
	"Audio — PipeWire + pamixer + pavucontrol"
	"Screenshot — grim + slurp + satty"
	"Clipboard — wl-clipboard + cliphist"
	"Dunst — notification daemon"
	"SwayNC — notification center"
	"System tools — btop, fastfetch, atuin, fzf, bat, eza, zoxide"
	"wlogout — logout menu"
	"Zellij — terminal multiplexer"
	"Fonts — Nerd Fonts + Rec Mono"
	"SDDM — display manager + Catppuccin theme"
	"Brave — web browser"
)
readonly -a COMP_GROUPS=(
	"BASE"
	"HYPRLAND"
	"HYPRLAND"
	"DESKTOP"
	"DESKTOP"
	"TERMINALS"
	"TERMINALS"
	"SHELL"
	"EDITORS"
	"EDITORS"
	"DEVELOPMENT"
	"FILES"
	"FILES"
	"MEDIA"
	"MEDIA"
	"TOOLS"
	"TOOLS"
	"NOTIFICATIONS"
	"NOTIFICATIONS"
	"SYSTEM"
	"SYSTEM"
	"SYSTEM"
	"APPEARANCE"
	"APPEARANCE"
	"APPLICATIONS"
)

# Selection state (0 = not selected, 1 = selected).
# Mutable array — do not declare readonly.
declare -a COMP_SELECTED=()
for _ in "${COMP_KEYS[@]}"; do
	COMP_SELECTED+=(0)
done

# ═══════════════════════════════════════════════════════════
# PREREQUISITES
# ═══════════════════════════════════════════════════════════
# Ensure the script is not run as root.
# Building AUR packages as root causes security issues,
# and config files would be created in /root instead of $HOME.
check_not_root() {
	if [[ "$EUID" -eq 0 ]]; then
		error "This script must not be run as root."
		info "Run as a normal user with sudo privileges."
		exit 1
	fi
}

check_internet() {
	info "Checking internet connection..."
	if ! curl --silent --max-time 5 --head "https://archlinux.org" >/dev/null 2>&1; then
		error "No internet connection."
		exit 1
	fi
	success "Internet connection OK."
}

# Install yay if missing. yay is required for AUR packages.
# AUR packages cannot be installed without it.
ensure_yay() {
	if command -v yay &>/dev/null; then
		return 0
	fi
	warn "yay (AUR helper) not found — installing..."
	# base-devel is required for makepkg (AUR package compilation)
	sudo pacman -S --needed --noconfirm base-devel git 2>&1 | tee -a "$LOG_FILE"
	local tmp_dir
	tmp_dir="$(mktemp -d)"
	trap 'rm -rf "$tmp_dir"' RETURN
	git clone --depth=1 --quiet "https://aur.archlinux.org/yay.git" "$tmp_dir/yay" 2>&1 | tee -a "$LOG_FILE"
	pushd "$tmp_dir/yay" >/dev/null
	makepkg -si --noconfirm 2>&1 | tee -a "$LOG_FILE"
	popd >/dev/null
	success "yay installed."
}

# ═══════════════════════════════════════════════════════════
# INSTALLATION HELPERS
# ═══════════════════════════════════════════════════════════
pacman_install() {
	if [[ ${#@} -eq 0 ]]; then return 0; fi
	info "pacman : ${*}"
	sudo pacman -S --needed --noconfirm "$@" 2>&1 | tee -a "$LOG_FILE" || true
}

aur_install() {
	if [[ ${#@} -eq 0 ]]; then return 0; fi
	info "yay (AUR) : ${*}"
	yay -S --needed --noconfirm "$@" 2>&1 | tee -a "$LOG_FILE" || true
}

# Copy a configuration directory from the repository to the destination.
# Creates a backup if the destination already exists.
copy_config() {
	local -r src="$1"
	local -r dst="$2"
	# If the source does not exist in the repository, warn and skip.
	if [[ ! -e "$src" ]]; then
		warn "Source not found in repository: ${src}"
		return 0
	fi
	# Backup existing config to avoid data loss.
	if [[ -e "$dst" ]]; then
		local dst_name
		dst_name="$(basename "$dst")"
		local backup_path="${BACKUP_DIR}/${dst_name}"
		mkdir -p "$BACKUP_DIR"
		cp -r "$dst" "$backup_path"
		dim " Backup: ${backup_path}"
	fi
	mkdir -p "$(dirname "$dst")"
	if [[ -d "$src" ]]; then
		# Copy directory contents (not the directory itself)
		mkdir -p "$dst"
		cp -r "${src}/." "$dst/"
	else
		# Simple file copy
		cp "$src" "$dst"
	fi
	success "Config copied → ${dst}"
}

# Enable a systemd service (user or system scope).
enable_service() {
	local -r service="$1"
	local -r scope="${2:-system}" # "system" or "user"
	if [[ "$scope" == "user" ]]; then
		systemctl --user enable "$service" 2>/dev/null &&
			success "User service enabled: ${service}" ||
			warn "Could not enable: ${service}"
	else
		sudo systemctl enable "$service" 2>/dev/null &&
			success "System service enabled: ${service}" ||
			warn "Could not enable: ${service}"
	fi
}

# ═══════════════════════════════════════════════════════════
# INSTALLATION FUNCTIONS — ONE PER COMPONENT
# ═══════════════════════════════════════════════════════════
install_core() {
	step "Base Tools"
	pacman_install base-devel git curl wget xdg-utils xdg-user-dirs \
		polkit-kde-agent networkmanager network-manager-applet
	enable_service NetworkManager
	# Create standard XDG directories (~/Documents, ~/Pictures, etc.)
	xdg-user-dirs-update 2>/dev/null || true
	success "Base tools installed."
}

install_hyprland() {
	step "Hyprland"
	pacman_install hyprland hyprlock hyprpaper hypridle \
		xdg-desktop-portal-hyprland \
		qt5-wayland qt6-wayland brightnessctl
	copy_config "${DOTS_DIR}/hyprland/hyprland.conf" "${HOME}/.config/hypr/hyprland.conf"
	copy_config "${DOTS_DIR}/hyprland/hyprlock.conf" "${HOME}/.config/hypr/hyprlock.conf"
	copy_config "${DOTS_DIR}/hyprland/hyprpaper.conf" "${HOME}/.config/hypr/hyprpaper.conf"
	copy_config "${DOTS_DIR}/hyprland/hypridle.conf" "${HOME}/.config/hypr/hypridle.conf"
	# Hyprland scripts (color-picker, rofi-search, screenshot)
	if [[ -d "${DOTS_DIR}/hyprland/scripts" ]]; then
		mkdir -p "${HOME}/.config/hypr/scripts"
		copy_config "${DOTS_DIR}/hyprland/scripts" "${HOME}/.config/hypr/scripts"
		chmod +x "${HOME}/.config/hypr/scripts/"*.sh 2>/dev/null || true
		success "Hyprland scripts made executable."
	fi
	warn "Place a wallpaper in ~/Pictures/wallpaper.jpg for hyprpaper."
}

install_pyprland() {
	step "Pyprland"
	aur_install pyprland
	copy_config "${DOTS_DIR}/pyprland/pyprland.toml" "${HOME}/.config/pyprland/pyprland.toml"
	info "Uncomment 'exec-once = pypr' in hyprland.conf to enable."
}

install_waybar() {
	step "Waybar"
	pacman_install waybar playerctl pamixer pavucontrol
	local src="${DOTS_DIR}/waybar/new"
	[[ -d "$src" ]] || src="${DOTS_DIR}/waybar"
	copy_config "$src" "${HOME}/.config/waybar"
	info "Waybar will be launched automatically by Hyprland."
}

install_rofi() {
	step "Rofi"
	pacman_install rofi-wayland
	local src="${DOTS_DIR}/rofi/new"
	[[ -d "$src" ]] || src="${DOTS_DIR}/rofi"
	copy_config "$src" "${HOME}/.config/rofi"
}

install_ghostty() {
	step "Ghostty"
	pacman_install ghostty
	copy_config "${DOTS_DIR}/ghostty" "${HOME}/.config/ghostty"
	info "Ghostty is the default terminal (\$terminal in hyprland.conf)."
}

install_kitty() {
	step "Kitty"
	pacman_install kitty
	copy_config "${DOTS_DIR}/kitty" "${HOME}/.config/kitty"
}

install_zsh() {
	step "Zsh + Oh My Zsh"
	pacman_install zsh zsh-completions
	if [[ -d "${HOME}/.oh-my-zsh" ]]; then
		warn "Oh My Zsh already installed — updating..."
		zsh "${HOME}/.oh-my-zsh/tools/upgrade.sh" 2>/dev/null || true
	else
		info "Installing Oh My Zsh..."
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" \
			--unattended 2>&1 | tee -a "$LOG_FILE"
	fi
	local omz_custom="${HOME}/.oh-my-zsh/custom"
	local -A plugins=(
		["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete.git"
		["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
		["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
	)
	for plugin_name in "${!plugins[@]}"; do
		local plugin_dir="${omz_custom}/plugins/${plugin_name}"
		if [[ -d "$plugin_dir" ]]; then
			info "Plugin already present: ${plugin_name}"
		else
			info "Installing plugin: ${plugin_name}"
			git clone --depth=1 --quiet "${plugins[$plugin_name]}" "$plugin_dir" 2>&1 | tee -a "$LOG_FILE"
			success "Plugin installed: ${plugin_name}"
		fi
	done
	local p10k_dir="${omz_custom}/themes/powerlevel10k"
	if [[ -d "$p10k_dir" ]]; then
		info "Powerlevel10k already present."
	else
		info "Installing Powerlevel10k..."
		git clone --depth=1 --quiet "https://github.com/romkatv/powerlevel10k.git" "$p10k_dir" 2>&1 | tee -a "$LOG_FILE"
		success "Powerlevel10k installed."
	fi
	copy_config "${DOTS_DIR}/zsh/.zshrc" "${HOME}/.zshrc"
	if [[ "$SHELL" != "$(which zsh)" ]]; then
		info "Changing default shell to Zsh..."
		chsh -s "$(which zsh)" && success "Shell changed to Zsh." ||
			warn "Could not change shell — do it manually: chsh -s \$(which zsh)"
	fi
	info "Run 'p10k configure' after first Zsh startup."
}

install_neovim() {
	step "Neovim + LazyVim"
	pacman_install neovim ripgrep fd tree-sitter-cli lazygit luarocks
	if [[ -d "${HOME}/.config/nvim" ]]; then
		local backup_nvim="${BACKUP_DIR}/nvim"
		mkdir -p "$BACKUP_DIR"
		cp -r "${HOME}/.config/nvim" "$backup_nvim"
		warn "nvim config backed up: ${backup_nvim}"
	fi
	if [[ -d "${DOTS_DIR}/nvim" ]]; then
		mkdir -p "${HOME}/.config/nvim"
		cp -r "${DOTS_DIR}/nvim/." "${HOME}/.config/nvim/"
		success "Neovim config copied."
	else
		warn "nvim/ directory not found in repository."
		info "Cloning LazyVim starter..."
		git clone --depth=1 --quiet "https://github.com/LazyVim/starter" \
			"${HOME}/.config/nvim" 2>&1 | tee -a "$LOG_FILE"
		rm -rf "${HOME}/.config/nvim/.git"
		success "LazyVim starter cloned — customize in ~/.config/nvim/lua/"
	fi
	info "Plugins will be installed automatically on first Neovim launch."
}

install_vscode() {
	step "VS Code"
	aur_install visual-studio-code-bin
	local vscode_dir="${HOME}/.config/Code/User"
	mkdir -p "$vscode_dir"
	copy_config "${DOTS_DIR}/vscode/settings.json" "${vscode_dir}/settings.json"
	info "Extensions must be installed manually in VS Code."
}

install_git() {
	step "Git"
	pacman_install git git-delta lazygit
	copy_config "${DOTS_DIR}/git/.gitconfig" "${HOME}/.gitconfig"
	copy_config "${DOTS_DIR}/git/.gitignore" "${HOME}/.gitignore"
	git config --global core.excludesfile "${HOME}/.gitignore" 2>/dev/null || true
	copy_config "${DOTS_DIR}/lazygit" "${HOME}/.config/lazygit"
	warn "Update your name and email in ~/.gitconfig."
}

install_thunar() {
	step "Thunar (File Manager)"
	pacman_install thunar thunar-volman thunar-archive-plugin gvfs dolphin
}

install_yazi() {
	step "Yazi (Terminal File Manager)"
	pacman_install yazi ffmpegthumbnailer poppler unarj
	aur_install glow
	copy_config "${DOTS_DIR}/yazi" "${HOME}/.config/yazi"
	if command -v ya &>/dev/null; then
		info "Installing Catppuccin flavor for Yazi..."
		ya pack -a catppuccin/yazi:macchiato 2>/dev/null ||
			warn "Could not install flavor via ya — local theme config will be used."
	fi
	if command -v bat &>/dev/null; then
		info "Installing Catppuccin theme for bat..."
		local bat_themes_dir
		bat_themes_dir="$(bat --config-dir)/themes"
		mkdir -p "$bat_themes_dir"
		curl --location --silent --output "${bat_themes_dir}/Catppuccin Macchiato.tmTheme" \
			"https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme" 2>/dev/null &&
			bat cache --build 2>/dev/null && success "bat theme installed." ||
			warn "Could not install bat theme — do it manually."
	fi
}

install_mpv() {
	step "mpv"
	pacman_install mpv
	copy_config "${DOTS_DIR}/mpv" "${HOME}/.config/mpv"
}

install_audio() {
	step "Audio (PipeWire)"
	pacman_install pipewire pipewire-alsa pipewire-pulse pipewire-jack \
		wireplumber pamixer pavucontrol playerctl
	systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null ||
		warn "PipeWire services should be enabled manually after reboot."
}

install_screenshot() {
	step "Screenshot"
	pacman_install grim slurp hyprpicker
	aur_install satty
	local scripts_dir="${HOME}/.config/hypr/scripts"
	if [[ -d "$scripts_dir" ]]; then
		chmod +x "${scripts_dir}"/*.sh 2>/dev/null || true
	fi
	mkdir -p "${HOME}/Pictures/Screenshots"
	success "Screenshots directory: ~/Pictures/Screenshots"
}

install_clipboard() {
	step "Clipboard"
	pacman_install wl-clipboard cliphist
	info "cliphist is launched automatically by Hyprland."
}

install_dunst() {
	step "Dunst (Notifications)"
	pacman_install dunst libnotify
	copy_config "${DOTS_DIR}/dunst" "${HOME}/.config/dunst"
	info "Dunst is launched automatically by Hyprland."
	warn "Note: Dunst uses Catppuccin Mocha (#1e1e2e) — different from Macchiato."
}

install_swaync() {
	step "SwayNC (Notification Center)"
	aur_install swaync
	copy_config "${DOTS_DIR}/swaync" "${HOME}/.config/swaync"
	warn "To enable SwayNC: replace dunst with swaync in hyprland.conf."
}

install_system() {
	step "System Tools"
	pacman_install btop fastfetch zoxide fzf bat eza fd ripgrep jq less
	aur_install atuin
	copy_config "${DOTS_DIR}/btop/btop.conf" "${HOME}/.config/btop/btop.conf"
	copy_config "${DOTS_DIR}/fastfetch" "${HOME}/.config/fastfetch"
	copy_config "${DOTS_DIR}/atuin/config.toml" "${HOME}/.config/atuin/config.toml"
	local btop_themes_dir="${HOME}/.config/btop/themes"
	mkdir -p "$btop_themes_dir"
	if [[ ! -f "${btop_themes_dir}/catppuccin_macchiato.theme" ]]; then
		info "Installing Catppuccin theme for btop..."
		curl --location --silent \
			--output "${btop_themes_dir}/catppuccin_macchiato.theme" \
			"https://github.com/catppuccin/btop/raw/main/themes/catppuccin_macchiato.theme" 2>/dev/null &&
			success "btop theme installed." ||
			warn "Could not download btop theme."
	fi
}

install_wlogout() {
	step "wlogout (Logout Menu)"
	aur_install wlogout
	copy_config "${DOTS_DIR}/wlogout" "${HOME}/.config/wlogout"
}

install_zellij() {
	step "Zellij"
	pacman_install zellij
	copy_config "${DOTS_DIR}/zellij" "${HOME}/.config/zellij"
}

install_fonts() {
	step "Fonts"
	pacman_install ttf-firacode-nerd ttf-jetbrains-mono-nerd ttf-meslo-nerd \
		ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono \
		noto-fonts noto-fonts-cjk noto-fonts-emoji
	warn "Rec Mono (main font) is not in the official repositories."
	warn "Download from: https://www.recursive.design/"
	warn "Or from GitHub: https://github.com/arrowtype/recursive/releases"
	info "After downloading, copy .ttf/.otf files to ~/.local/share/fonts/"
	info "Then update cache: fc-cache -fv"
	fc-cache -fv 2>/dev/null | grep -i "recursive\|rec mono" || true
	success "Font cache updated."
}

install_sddm() {
	step "SDDM + Catppuccin Theme"
	pacman_install sddm qt6-svg qt6-declarative qt5-quickcontrols2
	sudo mkdir -p /etc/sddm.conf.d
	if [[ -f "${DOTS_DIR}/sddm/sddm.conf" ]]; then
		sudo cp "${DOTS_DIR}/sddm/sddm.conf" /etc/sddm.conf.d/sddm.conf
		success "SDDM configuration copied."
	fi
	local theme_script="${DOTS_DIR}/scripts/install-sddm-theme.sh"
	if [[ -x "$theme_script" ]]; then
		"$theme_script"
	else
		warn "SDDM theme script not found: ${theme_script}"
		info "Install manually: ./scripts/install-sddm-theme.sh"
	fi
	enable_service sddm
}

install_brave() {
	step "Brave"
	aur_install brave-bin
	info "Brave is the default browser (\$browser in hyprland.conf)."
}

# ═══════════════════════════════════════════════════════════
# INTERACTIVE MENU
# ═══════════════════════════════════════════════════════════
print_header() {
	clear
	printf "${BOLD}${BLUE}"
	printf "╔═══════════════════════════════════════════════════════════╗\n"
	printf "║           dots-files — Selective Installer               ║\n"
	printf "║     Arch Linux · Hyprland · Catppuccin Macchiato         ║\n"
	printf "╚═══════════════════════════════════════════════════════════╝${RESET}\n\n"
}

print_menu() {
	print_header
	local current_group=""
	for i in "${!COMP_KEYS[@]}"; do
		local group="${COMP_GROUPS[$i]}"
		local num=$((i + 1))
		if [[ "$group" != "$current_group" ]]; then
			current_group="$group"
			printf "\n ${DIM}─── %s ${RESET}\n" "$group"
		fi
		if [[ "${COMP_SELECTED[$i]}" -eq 1 ]]; then
			printf " ${GREEN}[x]${RESET} ${BOLD}%2d.${RESET} %s\n" \
				"$num" "${COMP_DESCS[$i]}"
		else
			printf " ${DIM}[ ]${RESET} ${DIM}%2d.${RESET} %s\n" \
				"$num" "${COMP_DESCS[$i]}"
		fi
	done
	printf "\n"
	printf " ${DIM}────────────────────────────────────────────────────${RESET}\n"
	printf " ${CYAN}a${RESET} Select all "
	printf " ${CYAN}n${RESET} Deselect all\n"
	printf " ${GREEN}i${RESET} Start installation "
	printf " ${RED}q${RESET} Quit\n\n"
	local count=0
	for s in "${COMP_SELECTED[@]}"; do
		[[ "$s" -eq 1 ]] && ((count++)) || true
	done
	printf " ${BOLD}${count}/${#COMP_KEYS[@]} components selected${RESET}\n\n"
}

toggle_component() {
	local -r idx="$1"
	COMP_SELECTED[$idx]=$((1 - COMP_SELECTED[$idx]))
}

select_all() {
	for i in "${!COMP_SELECTED[@]}"; do
		COMP_SELECTED[$i]=1
	done
}

deselect_all() {
	for i in "${!COMP_SELECTED[@]}"; do
		COMP_SELECTED[$i]=0
	done
}

menu_loop() {
	while true; do
		print_menu
		read -rp " Choice (number / a / n / i / q) : " input
		case "$input" in
		[qQ])
			printf "\nGoodbye.\n\n"
			exit 0
			;;
		[aA]) select_all ;;
		[nN]) deselect_all ;;
		[iI])
			local has_selection=0
			for s in "${COMP_SELECTED[@]}"; do
				[[ "$s" -eq 1 ]] && has_selection=1 && break
			done
			if [[ "$has_selection" -eq 0 ]]; then
				warn "No component selected."
				sleep 1
			else
				break
			fi
			;;
		'' | *[!0-9]*)
			;;
		*)
			local num="$input"
			local idx=$((num - 1))
			if [[ "$idx" -ge 0 && "$idx" -lt "${#COMP_KEYS[@]}" ]]; then
				toggle_component "$idx"
			else
				warn "Invalid number: ${num}"
				sleep 0.5
			fi
			;;
		esac
	done
}

confirm_installation() {
	print_header
	printf "${BOLD}The following components will be installed:${RESET}\n\n"
	for i in "${!COMP_KEYS[@]}"; do
		if [[ "${COMP_SELECTED[$i]}" -eq 1 ]]; then
			printf " ${GREEN}✓${RESET} %s\n" "${COMP_DESCS[$i]}"
		fi
	done
	printf "\n${YELLOW} Existing configurations will be backed up to:${RESET}\n"
	printf " ${DIM}${BACKUP_DIR}${RESET}\n\n"
	read -rp " Confirm installation? [y/N] " response
	if [[ "${response,,}" != "y" && "${response,,}" != "yes" ]]; then
		info "Installation cancelled."
		exit 0
	fi
}

run_installation() {
	print_header
	printf "${BOLD}Installation in progress...${RESET}\n"
	printf "${DIM} Full log: ${LOG_FILE}${RESET}\n\n"
	echo "=== dots-files install — $(date) ===" >"$LOG_FILE"
	echo "DOTS_DIR=${DOTS_DIR}" >>"$LOG_FILE"
	ensure_yay
	for i in "${!COMP_KEYS[@]}"; do
		if [[ "${COMP_SELECTED[$i]}" -eq 1 ]]; then
			local key="${COMP_KEYS[$i]}"
			local func="install_${key}"
			if declare -f "$func" >/dev/null; then
				"$func"
			else
				warn "Installation function not found: ${func}"
			fi
		fi
	done
}

print_summary() {
	printf "\n${BOLD}${GREEN}"
	printf "╔═══════════════════════════════════════════════════════════╗\n"
	printf "║              Installation Completed!                      ║\n"
	printf "╚═══════════════════════════════════════════════════════════╝${RESET}\n\n"
	printf "${BOLD}Installed components:${RESET}\n\n"
	for i in "${!COMP_KEYS[@]}"; do
		if [[ "${COMP_SELECTED[$i]}" -eq 1 ]]; then
			printf " ${GREEN}✓${RESET} %s\n" "${COMP_DESCS[$i]}"
		fi
	done
	printf "\n${BOLD}Next steps:${RESET}\n"
	printf " ${BLUE}→${RESET} Place a wallpaper in ~/Pictures/wallpaper.jpg\n"
	printf " ${BLUE}→${RESET} Install Rec Mono font (see packages list)\n"
	printf " ${BLUE}→${RESET} Reboot: \`reboot\`\n"
	printf " ${BLUE}→${RESET} First Zsh launch: \`p10k configure\`\n"
	printf " ${BLUE}→${RESET} First Neovim launch: wait for plugins to install\n"
	if [[ -d "$BACKUP_DIR" ]]; then
		printf "\n ${YELLOW}Backups created in:${RESET} ${DIM}${BACKUP_DIR}${RESET}\n"
	fi
	printf "\n ${DIM}Full log: ${LOG_FILE}${RESET}\n\n"
}

main() {
	touch "$LOG_FILE"
	check_not_root
	check_internet
	menu_loop
	confirm_installation
	run_installation
	print_summary
}

main "$@"
