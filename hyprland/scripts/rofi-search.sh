#!/usr/bin/env bash
set -euo pipefail

# ═══════════════════════════════════════════════════════════
# ROFI SEARCH - Quick Search Launcher with Bang Support
# ═══════════════════════════════════════════════════════════
#
# Description:
#   Quick web search launcher using Rofi with DuckDuckGo bang
#   support. Type a prefix (e.g., "yt lofi") or DuckDuckGo
#   bang (!gh bash) to search specific sites instantly.
#
# Location:
#   ~/.config/hypr/scripts/rofi-search.sh
#
# Installation:
#   Referenced by hyprland.conf.
#   Dependencies: rofi, curl (optional for some features)
#
# Usage:
#   SUPER + SHIFT + SPACE  → opens Rofi search prompt
#
# Syntax:
#   <prefix> <query>   → local bang mapping (see BANGS below)
#   !<bang> <query>    → DuckDuckGo bang forwarding
#   <query>            → plain DuckDuckGo search
#
# Examples:
#   "linux kernel"      → DuckDuckGo: "linux kernel"
#   "g border-radius"   → Google search
#   "yt lofi beats"     → YouTube search
#   "mdn flexbox"       → MDN Web Docs
#   "npm tailwindcss"   → npmjs.com
#   "!gh bash"          → DuckDuckGo bang: GitHub search
#
# Author:
#   Souleymane Sy
#
# Bang references:
#   Full DDG bang list: https://duckduckgo.com/bang
#
# Dependencies:
#   - rofi   (search prompt UI)
#
# See also:
#   hyprland/hyprland.conf                 (keybinding)
#   hyprland/scripts/screenshot.sh         (screenshot utility)
#   hyprland/scripts/color-picker.sh       (color picker)
#
# Documentation:
#   https://github.com/davatorium/rofi

readonly BROWSER="xdg-open"

# ─── Local bang mappings ──────────────────────────────────
# Format: ["prefix"]="https://example.com/search?q=%s"
# %s is replaced with the URL-encoded search term.
declare -A BANGS=(
	# General
	["g"]="https://www.google.com/search?q=%s"
	["ddg"]="https://duckduckgo.com/?q=%s"
	["sp"]="https://www.startpage.com/search?q=%s"

	# Development
	["gh"]="https://github.com/search?q=%s"
	["mdn"]="https://developer.mozilla.org/en-US/search?q=%s"
	["npm"]="https://www.npmjs.com/search?q=%s"
	["crates"]="https://crates.io/search?q=%s"
	["aw"]="https://wiki.archlinux.org/index.php?search=%s"

	# Media & Shopping
	["yt"]="https://www.youtube.com/results?search_query=%s"
	["amz"]="https://www.amazon.com/s?k=%s"

	# AI
	["claude"]="https://claude.ai/new?q=%s"
	["gpt"]="https://chat.openai.com/?q=%s"
	["grok"]="https://grok.x.ai/?q=%s"
	["perplexity"]="https://www.perplexity.ai/search?q=%s"
)

# ─── Dependency check ─────────────────────────────────────
check_dependencies() {
	local -r deps=("xdg-open" "rofi")
	local dep

	for dep in "${deps[@]}"; do
		if ! command -v "$dep" >/dev/null 2>&1; then
			echo "Error: Missing dependency '${dep}'." >&2
			exit 1
		fi
	done
}

# ─── URL encode ───────────────────────────────────────────
# Uses jq when available (fast path).
# printf avoids the trailing newline that<<<would encode as %0A.
# Falls back to a pure-bash implementation when jq is absent.
urlencode() {
	local input="$1"

	if command -v jq >/dev/null 2>&1; then
		printf '%s' "$input" | jq -sRr @uri
		return
	fi

	local encoded="" char
	local i

	for ((i = 0; i < ${#input}; i++)); do
		char="${input:$i:1}"
		case "$char" in
		[a-zA-Z0-9.~_-]) encoded+="$char" ;;
		*) encoded+=$(printf '%%%02X' "'$char") ;;
		esac
	done

	printf '%s' "$encoded"
}

# ─── Rofi prompt ─────────────────────────────────────────
# Inherits the full Catppuccin Macchiato theme from config.rasi.
# Only overrides listview to disable it — this is a plain input,
# not an app launcher, so no suggestion list is needed.
prompt_query() {
	rofi -dmenu \
		-i \
		-p "  Search" \
		-theme-str 'listview { enabled: false; }' \
		</dev/null
}

# ─── Parse query into prefix + rest ──────────────────────
# Returns via globals PREFIX and REST.
# If there is no space, PREFIX = full query and REST = "".
parse_query() {
	local query="$1"

	if [[ "$query" == *" "* ]]; then
		PREFIX="${query%% *}"
		REST="${query#* }"
	else
		PREFIX="$query"
		REST=""
	fi
}

# ─── Build URL from raw query ─────────────────────────────
# Three resolution paths (in order):
#   1. Starts with "!" → DuckDuckGo bang (forwarded as-is)
#   2. Prefix in BANGS → local mapping with encoded rest
#   3. Anything else   → plain DuckDuckGo search
build_url() {
	local query="$1"
	local encoded url

	# Path 1: explicit DDG bang — user typed "!gh bash" etc.
	if [[ "$query" == "!"* ]]; then
		encoded=$(urlencode "$query")
		printf 'https://duckduckgo.com/?q=%s' "$encoded"
		return
	fi

	parse_query "$query"

	# Path 2: known local prefix
	if [[ -n "${BANGS[$PREFIX]+_}" ]]; then
		encoded=$(urlencode "$REST")
		url="${BANGS[$PREFIX]//%s/$encoded}"
		printf '%s' "$url"
		return
	fi

	# Path 3: plain search — full query forwarded to DDG
	encoded=$(urlencode "$query")
	printf 'https://duckduckgo.com/?q=%s' "$encoded"
}

# ─── Main ─────────────────────────────────────────────────
main() {
	check_dependencies

	local query
	query=$(prompt_query)

	# Exit silently if the user dismissed Rofi without typing
	[[ -z "$query" ]] && exit 0

	local url
	url=$(build_url "$query")

	# Launch browser detached from this script
	$BROWSER "$url" &
	disown
}

main "$@"
