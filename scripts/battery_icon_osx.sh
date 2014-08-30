#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# script global variables
charged_icon=""
charging_icon=""
discharging_icon=""

charged_default="❇ "
charged_default_osx="🔋 "
charging_default="⚡️ "
discharging_default=""

source "$CURRENT_DIR/helpers.sh"

charged_default() {
	if is_osx; then
		echo "$charged_default_osx"
	else
		echo "$charged_default"
	fi
}

# icons are set as script global variables
get_icon_settings() {
	charged_icon=$(get_tmux_option "@batt_charged_icon" || echo "$(charged_default)")
	charging_icon=$(get_tmux_option "@batt_charging_icon" || echo "$charging_default")
	discharging_icon=$(get_tmux_option "@batt_discharging_icon" || echo "$discharging_default")
}

battery_status() {
	# "charged", "charging" or "discharging" is the 3rd field on the second line
	if command_exists "pmset"; then
		pmset -g batt | awk 'NR==2 { print $3 }'
	elif command_exists "upower"; then
		battery=$(upower -e | grep battery | head -1)
		upower -i $battery | grep state | awk '{print $2}'
	fi
}

print_icon() {
	local status=$1
	if [[ $status =~ (charged) ]]; then
		printf "$charged_icon"
	elif [[ $status =~ (^charging) ]]; then
		printf "$charging_icon"
	elif [[ $status =~ (^discharging) ]]; then
		printf "$discharging_icon"
	fi
}

main() {
	get_icon_settings
	local status=$(battery_status)
	print_icon "$status"
}
main
