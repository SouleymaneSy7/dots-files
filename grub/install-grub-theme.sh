#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# INSTALL-GRUB-THEME - Catppuccin Macchiato Theme for GRUB
# ═══════════════════════════════════════════════════════════
#
# Author: Souleymane Sy
#
# Description:
# Clones the official catppuccin/grub repository and installs
# the Catppuccin Macchiato theme in /boot/grub/themes/.
# Updates /etc/default/grub to enable the theme and then
# regenerates grub.cfg using grub-mkconfig.
#
# Usage:
# ./scripts/install-grub-theme.sh
# Or via the main installer: ./install.sh
#
# Dependencies:
# - git (repository clone)
# - grub (target — must be installed)
# - sudo (write permissions in /boot and /etc)
#
# Result:
# - /boot/grub/themes/catppuccin-macchiato-grub-theme/
# - /etc/default/grub (GRUB_THEME updated)
# - /boot/grub/grub.cfg (regenerated)
#
# Warning:
# This script modifies /etc/default/grub and regenerates grub.cfg.
# On an MBR/BIOS system, make sure GRUB is installed on the
# correct disk before running this script.
#
# Documentation:
# https://github.com/catppuccin/grub

# ─── Configuration ────────────────────────────────────────
readonly THEME_REPO="https://github.com/catppuccin/grub.git"
readonly THEME_NAME="catppuccin-macchiato-grub-theme"
readonly GRUB_THEMES_DIR="/boot/grub/themes"
readonly GRUB_CONFIG="/etc/default/grub"
readonly GRUB_CFG="/boot/grub/grub.cfg"

# ─── Colors ───────────────────────────────────────────────
readonly BLUE='\033[34m'
readonly GREEN='\033[32m'
readonly RED='\033[31m'
readonly YELLOW='\033[33m'
readonly BOLD='\033[1m'
readonly RESET='\033[0m'

# ─── Helpers ──────────────────────────────────────────────
info() { printf "${BLUE} →${RESET} %s\n" "$*"; }
success() { printf "${GREEN} ✓${RESET} %s\n" "$*"; }
error() { printf "${RED} ✗${RESET} %s\n" "$*" >&2; }
warn() { printf "${YELLOW} !${RESET} %s\n" "$*"; }
step() { printf "\n${BOLD}${BLUE}── %s${RESET}\n" "$*"; }

# ─── Dependency Check ─────────────────────────────────────
check_dependencies() {
	local -r deps=("git" "grub-mkconfig")
	local missing=()
	for dep in "${deps[@]}"; do
		if ! command -v "$dep" &>/dev/null; then
			missing+=("$dep")
		fi
	done
	if [[ ${#missing[@]} -gt 0 ]]; then
		error "Missing dependencies: ${missing[*]}"
		info "Install GRUB with: sudo pacman -S grub"
		exit 1
	fi
	# Check that /boot/grub exists — indicates GRUB is installed
	# on this system. Without it, modifying grub.cfg would be dangerous.
	if [[ ! -d "/boot/grub" ]]; then
		error "/boot/grub not found — GRUB does not appear to be installed."
		info "Install GRUB: sudo pacman -S grub && sudo grub-install /dev/sdX"
		exit 1
	fi
	# Check that /etc/default/grub exists for GRUB_THEME update
	if [[ ! -f "$GRUB_CONFIG" ]]; then
		error "${GRUB_CONFIG} not found."
		exit 1
	fi
}

# ─── Clone Theme Repository ───────────────────────────────
clone_theme_repo() {
	local -r tmp_dir="$1"
	info "Cloning catppuccin/grub repository..."
	info "URL: ${THEME_REPO}"
	# Shallow clone (--depth=1): we only need the latest commit,
	# not the full history. Significantly reduces clone time.
	if ! git clone --depth=1 --quiet "$THEME_REPO" "$tmp_dir"; then
		error "Failed to clone repository."
		info "Check your internet connection or the URL: ${THEME_REPO}"
		exit 1
	fi
	# Verify that the Macchiato theme directory exists in the repo
	if [[ ! -d "${tmp_dir}/src/${THEME_NAME}" ]]; then
		error "Theme '${THEME_NAME}' not found in the repository."
		info "Available themes: $(ls "${tmp_dir}/src/" 2>/dev/null || echo 'unknown')"
		exit 1
	fi
	success "Repository cloned."
}

# ─── Install Theme ────────────────────────────────────────
install_theme() {
	local -r src_dir="$1"
	step "Installing theme in ${GRUB_THEMES_DIR}"
	sudo mkdir -p "$GRUB_THEMES_DIR"
	# Remove previous version to avoid file conflicts.
	# The GRUB theme consists of interdependent files (images,
	# configuration files) — a partial update would be risky.
	if [[ -d "${GRUB_THEMES_DIR}/${THEME_NAME}" ]]; then
		warn "Existing theme detected — replacing..."
		sudo rm -rf "${GRUB_THEMES_DIR:?}/${THEME_NAME}"
	fi
	info "Copying theme files..."
	sudo cp -r "${src_dir}/src/${THEME_NAME}" "${GRUB_THEMES_DIR}/"
	# Read permissions for all users — GRUB in boot phase
	# does not have access to normal user permissions.
	sudo chmod -R a+r "${GRUB_THEMES_DIR}/${THEME_NAME}"
	sudo find "${GRUB_THEMES_DIR}/${THEME_NAME}" -type d -exec chmod 755 {} \;
	success "Theme installed: ${GRUB_THEMES_DIR}/${THEME_NAME}"
}

# ─── Update /etc/default/grub ─────────────────────────────
update_grub_config() {
	local -r theme_path="${GRUB_THEMES_DIR}/${THEME_NAME}/theme.txt"
	step "Updating ${GRUB_CONFIG}"
	# Backup /etc/default/grub before modification.
	# This is a critical file: a syntax error can prevent
	# grub.cfg regeneration and block booting.
	local backup="${GRUB_CONFIG}.bak.$(date +%Y%m%d%H%M%S)"
	sudo cp "$GRUB_CONFIG" "$backup"
	warn "Backup created: ${backup}"
	# Check if GRUB_THEME is already defined
	if grep -q "^GRUB_THEME=" "$GRUB_CONFIG"; then
		# Replace existing value using sed.
		# Using '|' as separator to avoid conflicts with '/' in the path.
		sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"${theme_path}\"|" "$GRUB_CONFIG"
		info "GRUB_THEME updated."
	else
		# Add the variable at the end if it doesn't exist.
		printf '\nGRUB_THEME="%s"\n' "$theme_path" | sudo tee -a "$GRUB_CONFIG" >/dev/null
		info "GRUB_THEME added."
	fi
	# Disable default background color so the theme
	# fully controls the GRUB screen appearance.
	if grep -q "^GRUB_COLOR_NORMAL=" "$GRUB_CONFIG"; then
		sudo sed -i 's|^GRUB_COLOR_NORMAL=|#GRUB_COLOR_NORMAL=|' "$GRUB_CONFIG"
		info "GRUB_COLOR_NORMAL disabled (theme takes full control)."
	fi
	success "GRUB configuration updated."
	info "GRUB_THEME=\"${theme_path}\""
}

# ─── Regenerate grub.cfg ──────────────────────────────────
regenerate_grub_cfg() {
	step "Regenerating ${GRUB_CFG}"
	# grub-mkconfig reads /etc/default/grub and generates a new grub.cfg.
	# This is the final step that activates the theme on next boot.
	# os-prober is run here if installed — it detects Windows
	# and other systems to add them to the GRUB menu.
	if ! sudo grub-mkconfig -o "$GRUB_CFG"; then
		error "Failed to regenerate grub.cfg."
		info "Restore config: sudo cp ${GRUB_CONFIG}.bak.* ${GRUB_CONFIG}"
		exit 1
	fi
	success "grub.cfg regenerated: ${GRUB_CFG}"
}

# ─── Main ─────────────────────────────────────────────────
main() {
	printf "\n${BOLD}${BLUE}"
	printf "═══════════════════════════════════════════════════\n"
	printf " GRUB — Catppuccin Macchiato Theme \n"
	printf "═══════════════════════════════════════════════════${RESET}\n\n"

	warn "This script will modify /etc/default/grub and regenerate grub.cfg."
	warn "A backup will be created automatically."
	printf "\n"
	read -rp "Continue? [y/N] " response
	if [[ "${response,,}" != "y" && "${response,,}" != "yes" ]]; then
		info "Installation cancelled."
		exit 0
	fi

	check_dependencies

	# Create a clean temporary directory for the clone.
	# mktemp -d guarantees a unique name with no collision.
	local tmp_dir
	tmp_dir="$(mktemp -d)"

	# Automatic cleanup of temporary directory on exit,
	# regardless of success, error, or Ctrl+C.
	trap 'rm -rf "$tmp_dir"' EXIT

	clone_theme_repo "$tmp_dir"
	install_theme "$tmp_dir"
	update_grub_config
	regenerate_grub_cfg

	printf "\n${GREEN}${BOLD}"
	printf "═══════════════════════════════════════════════════\n"
	printf " GRUB theme installed successfully. \n"
	printf " The theme will be visible on next boot. \n"
	printf "═══════════════════════════════════════════════════${RESET}\n\n"
}

main "$@"
