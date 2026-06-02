#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# SCREENSHOT - Hyprland / Wayland Capture Script
# ═══════════════════════════════════════════════════════════
#
# Description:
#   Screenshot utility for Hyprland using grim, slurp, and
#   satty. Supports region selection and full-screen capture,
#   with annotation and auto-save to ~/Pictures/Screenshots.
#
# Location:
#   ~/.config/hypr/scripts/screenshot.sh
#
# Installation:
#   Referenced by hyprland.conf.
#   Dependencies: grim, slurp, satty, wl-clipboard
#
# Usage:
#   screenshot.sh region   → interactive area selection
#   screenshot.sh full     → capture entire screen
#
#   Both modes open the capture in satty for annotation,
#   then save to ~/Pictures/Screenshots and copy to clipboard.
#
# Keybindings (hyprland.conf):
#   SUPER + PRINT   → region selection (draw with mouse)
#   PRINT           → full screenshot (all monitors)
#
# Author:
#   Souleymane Sy
#
# Dependencies:
#   - grim       (Wayland screenshot tool)
#   - slurp      (region selection)
#   - satty      (annotation)
#   - wl-clipboard  (clipboard copy)
#   - notify-send   (optional — dunst notifications)
#
# See also:
#   hyprland/hyprland.conf                 (keybindings)
#   hyprland/scripts/color-picker.sh       (color picker)
#   hyprland/scripts/rofi-search.sh        (search launcher)
#
# Documentation:
#   https://wiki.archlinux.org/title/Screen_capture

# ─── Config ───────────────────────────────────────────────
readonly SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
readonly DATE_FMT="%Y-%m-%d_%H-%M-%S"
readonly FILE_PREFIX="screenshot"

# ─── Helpers ──────────────────────────────────────────────

# Build the full output path with a timestamped filename.
make_outfile() {
	printf '%s/%s-%s.png' "$SCREENSHOT_DIR" "$FILE_PREFIX" "$(date +"$DATE_FMT")"
}

# Send a desktop notification if notify-send is available.
# $1 = summary, $2 = body (optional)
notify() {
	command -v notify-send >/dev/null 2>&1 || return 0
	notify-send --app-name "Screenshot" --icon "camera-photo" "$1" "${2:-}"
}

# ─── Dependency check ─────────────────────────────────────
# Core deps are always required. slurp is only needed for region mode.
check_dependencies() {
	local -r core_deps=("grim" "satty" "wl-copy")
	local dep

	for dep in "${core_deps[@]}"; do
		if ! command -v "$dep" >/dev/null 2>&1; then
			echo "Error: Missing dependency '${dep}'." >&2
			exit 1
		fi
	done
}

check_slurp() {
	if ! command -v slurp >/dev/null 2>&1; then
		echo "Error: Missing dependency 'slurp' (required for region mode)." >&2
		exit 1
	fi
}

# ─── Satty pipeline ───────────────────────────────────────
# Receives a grim capture on stdin, opens it in satty.
# On Enter: saves to $OUTFILE and copies to clipboard.
# $1 = output file path
open_in_satty() {
	local outfile="$1"

	satty --filename - \
		--output-filename "$outfile" \
		--early-exit \
		--actions-on-enter save-to-clipboard \
		--copy-command 'wl-copy'
}

# ─── Capture modes ────────────────────────────────────────

# Draw a rectangle with the mouse to select a region.
# Pressing Esc cancels silently.
# If slurp is already running (e.g. double-tap), kill it and exit.
capture_region() {
	check_slurp

	# Toggle: kill any active selection and exit cleanly.
	pkill -x slurp && exit 0

	local region
	# slurp exits non-zero on Esc; || true prevents set -e from aborting.
	region=$(slurp || true)

	# User cancelled — exit without error or notification.
	[[ -z "$region" ]] && exit 0

	local outfile
	outfile=$(make_outfile)

	grim -g "$region" - | open_in_satty "$outfile"

	notify "Screenshot saved" "$outfile"
}

# Capture all connected monitors in a single image.
capture_full() {
	local outfile
	outfile=$(make_outfile)

	# grim without -g captures the full compositor output.
	grim - | open_in_satty "$outfile"

	notify "Screenshot saved" "$outfile"
}

# ─── Main ─────────────────────────────────────────────────
main() {
	local mode="${1:-}"

	if [[ -z "$mode" ]]; then
		echo "Usage: $(basename "$0") [region|full]" >&2
		exit 1
	fi

	check_dependencies
	mkdir -p "$SCREENSHOT_DIR"

	case "$mode" in
	region) capture_region ;;
	full) capture_full ;;
	*)
		echo "Error: Unknown mode '${mode}'. Expected 'region' or 'full'." >&2
		exit 1
		;;
	esac
}

main "$@"
