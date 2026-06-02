#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# COLOR PICKER - Format-Aware Screen Color Picker
# ═══════════════════════════════════════════════════════════
#
# Description:
#   Picks any pixel on screen and copies its color value to
#   the clipboard in a chosen format (HEX, RGB, HSL, etc.).
#   Uses hyprpicker for capture and Rofi for format selection.
#
# Location:
#   ~/.config/hypr/scripts/color-picker.sh
#
# Installation:
#   Referenced by hyprland.conf.
#   Dependencies: hyprpicker, rofi
#
# Usage:
#   SUPER + P  → triggers the script
#   Flow:
#     1. Pick a color format via Rofi menu
#     2. Click any pixel on screen
#     3. Result is auto-copied to clipboard
#
# Author:
#   Souleymane Sy
#
# Dependencies:
#   - hyprpicker  (screen pixel capture)
#   - rofi        (format selection menu)
#
# See also:
#   hyprland/hyprland.conf              (keybinding: SUPER + P)
#   hyprland/scripts/screenshot.sh      (screenshot utility)
#   hyprland/scripts/rofi-search.sh     (search launcher)
#
# Documentation:
#   https://github.com/hyprwm/hyprpicker

readonly LOCK="/tmp/hyprpicker.lock"

# ─── Dependency check ─────────────────────────────────────
check_dependencies() {
	local -r deps=("hyprpicker" "rofi")
	local dep

	for dep in "${deps[@]}"; do
		if ! command -v "$dep" >/dev/null 2>&1; then
			echo "Error: Missing dependency '${dep}'." >&2
			exit 1
		fi
	done
}

# ─── Format picker via Rofi ───────────────────────────────
# Inherits the full Catppuccin Macchiato theme from config.rasi.
# listview stays enabled — this is a short list, not a plain input.
pick_format() {
	printf '%s\n' hex rgb hsl hsv cmyk |
		rofi -dmenu \
			-i \
			-p "󰏘  Color Format"
}

# ─── Main ─────────────────────────────────────────────────
main() {
	check_dependencies

	# Toggle: kill hyprpicker if already running (second keypress cancels)
	pkill -x hyprpicker && exit 0

	# Acquire a non-blocking lock to prevent duplicate menus.
	# If the menu is already open, exit silently.
	exec 9>"$LOCK"
	if ! flock -n 9; then
		exit 0
	fi

	local format
	format=$(pick_format)

	# Release lock before launching hyprpicker.
	# hyprpicker is long-running (user must click a pixel) — holding
	# the lock during that would block any subsequent invocation.
	flock -u 9
	exec 9>&-

	# User cancelled Rofi without selecting
	[[ -z "$format" ]] && exit 0

	# -a: auto-copy result to clipboard
	# -f: output in the chosen format
	hyprpicker -a -f "$format"
}

main "$@"
