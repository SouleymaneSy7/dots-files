#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# INSTALL-SDDM-THEME - Catppuccin Macchiato Blue Theme for SDDM
# ═══════════════════════════════════════════════════════════
#
# Author: Souleymane Sy
#
# Description:
# Downloads and installs the official Catppuccin Macchiato Blue
# theme for SDDM from the GitHub releases.
# Also sets up the configuration in /etc/sddm.conf.d/
# to enable the theme and pre-fill session settings.
#
# Usage:
# ./scripts/install-sddm-theme.sh
# Or via the main installer: ./install.sh
#
# Dependencies:
# - curl (download)
# - unzip (archive extraction)
# - sddm (target — must be installed)
# - sudo (write permissions in /usr/share and /etc)
#
# Result:
# - /usr/share/sddm/themes/catppuccin-macchiato-blue/
# - /etc/sddm.conf.d/sddm.conf
#
# Documentation:
# https://github.com/catppuccin/sddm

# ─── Configuration ────────────────────────────────────────
readonly THEME_NAME="catppuccin-macchiato-blue"
readonly THEME_DIR="/usr/share/sddm/themes"
readonly SDDM_CONF_DIR="/etc/sddm.conf.d"
readonly SDDM_CONF="${SDDM_CONF_DIR}/sddm.conf"

# URL of the latest GitHub release. The path /latest/download/
# automatically redirects to the most recent release archive,
# avoiding the need to hard-code a version number.
readonly RELEASE_URL="https://github.com/catppuccin/sddm/releases/latest/download/${THEME_NAME}.zip"

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
	local -r deps=("curl" "unzip")
	local missing=()
	for dep in "${deps[@]}"; do
		if ! command -v "$dep" &>/dev/null; then
			missing+=("$dep")
		fi
	done
	if [[ ${#missing[@]} -gt 0 ]]; then
		error "Missing dependencies: ${missing[*]}"
		info "Install with: sudo pacman -S ${missing[*]}"
		exit 1
	fi
	# Check that SDDM is installed before installing a theme.
	# Installing a theme without SDDM would be useless.
	if ! command -v sddm &>/dev/null && [[ ! -d "$THEME_DIR" ]]; then
		error "SDDM is not installed."
		info "Install with: sudo pacman -S sddm"
		exit 1
	fi
}

# ─── Download Theme ───────────────────────────────────────
download_theme() {
	local tmp_archive
	tmp_archive="$(mktemp --suffix='.zip')"
	info "Downloading ${THEME_NAME}..."
	info "URL: ${RELEASE_URL}"
	# --location follows redirects (GitHub redirects /latest/download/)
	# --fail makes the command fail on HTTP errors (404, 403, etc.)
	# --show-error shows the error even with --silent
	if ! curl --location --fail --show-error --progress-bar \
		--output "$tmp_archive" \
		"$RELEASE_URL"; then
		rm -f "$tmp_archive"
		error "Download failed."
		info "Check your internet connection or the URL: ${RELEASE_URL}"
		exit 1
	fi
	printf '%s' "$tmp_archive"
}

# ─── Install Theme ────────────────────────────────────────
install_theme() {
	local -r archive="$1"
	step "Installing theme in ${THEME_DIR}"
	# Create themes directory if it doesn't exist
	sudo mkdir -p "$THEME_DIR"
	# Remove previous installation if it exists.
	# A corrupted partial installation could cause problems for SDDM.
	if [[ -d "${THEME_DIR}/${THEME_NAME}" ]]; then
		warn "Existing theme detected — replacing..."
		sudo rm -rf "${THEME_DIR:?}/${THEME_NAME}"
	fi
	info "Extracting archive..."
	sudo unzip -q "$archive" -d "$THEME_DIR"
	# Verify that extraction produced the expected directory
	if [[ ! -d "${THEME_DIR}/${THEME_NAME}" ]]; then
		error "Extraction failed: ${THEME_DIR}/${THEME_NAME} not found."
		exit 1
	fi
	# Clean up permissions — SDDM runs as _sddm, files must be readable
	# but don't need to be executable.
	sudo find "${THEME_DIR}/${THEME_NAME}" -type f -exec chmod 644 {} \;
	sudo find "${THEME_DIR}/${THEME_NAME}" -type d -exec chmod 755 {} \;
	success "Theme installed: ${THEME_DIR}/${THEME_NAME}"
}

# ─── SDDM Configuration ───────────────────────────────────
write_sddm_config() {
	step "Configuring SDDM"
	sudo mkdir -p "$SDDM_CONF_DIR"
	# Backup existing configuration before overwriting.
	# A drop-in file in sddm.conf.d/ overrides /etc/sddm.conf
	# without modifying it, which is cleaner and more maintainable.
	if [[ -f "$SDDM_CONF" ]]; then
		local backup="${SDDM_CONF}.bak.$(date +%Y%m%d%H%M%S)"
		sudo cp "$SDDM_CONF" "$backup"
		warn "Configuration backed up: ${backup}"
	fi
	info "Writing ${SDDM_CONF}..."
	# Write configuration via heredoc passed to sudo tee.
	# tee is used because redirection > does not preserve sudo rights.
	sudo tee "$SDDM_CONF" >/dev/null <<EOF
# ═══════════════════════════════════════════════════════════
# SDDM - Display Manager Configuration
# ═══════════════════════════════════════════════════════════
#
# Drop-in file: /etc/sddm.conf.d/sddm.conf
# Generated by: dots-files/scripts/install-sddm-theme.sh
#
# This file overrides /etc/sddm.conf without modifying it.
# Documentation: https://wiki.archlinux.org/title/SDDM
[Theme]
Current=${THEME_NAME}
[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot
Numlock=on
[Users]
RememberLastUser=true
HideUsers=root
[Session]
DefaultSession=hyprland
EOF
	success "Configuration written: ${SDDM_CONF}"
}

# ─── Enable Service ───────────────────────────────────────
enable_sddm() {
	step "Enabling SDDM service"
	# Enable only if the service is not already enabled.
	# On a fresh install, SDDM is usually not yet enabled as display manager.
	if systemctl is-enabled sddm &>/dev/null; then
		info "SDDM is already enabled."
	else
		sudo systemctl enable sddm
		success "SDDM service enabled."
	fi
}

# ─── Main ─────────────────────────────────────────────────
main() {
	printf "\n${BOLD}${BLUE}"
	printf "═══════════════════════════════════════════════════\n"
	printf " SDDM — Catppuccin Macchiato Blue Theme \n"
	printf "═══════════════════════════════════════════════════${RESET}\n\n"

	check_dependencies

	local tmp_archive
	tmp_archive="$(download_theme)"

	# Ensure temporary file is deleted on exit,
	# regardless of success, error, or Ctrl+C.
	trap 'rm -f "$tmp_archive"' EXIT

	install_theme "$tmp_archive"
	write_sddm_config

	# Offer to enable the service — don't force it on systems
	# that use another display manager.
	printf "\n"
	read -rp "Enable SDDM service? [y/N] " response
	if [[ "${response,,}" == "y" || "${response,,}" == "yes" ]]; then
		enable_sddm
	else
		warn "SDDM service not enabled — do it manually: sudo systemctl enable sddm"
	fi

	printf "\n${GREEN}${BOLD}"
	printf "═══════════════════════════════════════════════════\n"
	printf " Installation completed successfully. \n"
	printf " Reboot to see the theme: sudo reboot \n"
	printf "═══════════════════════════════════════════════════${RESET}\n\n"
}

main "$@"
