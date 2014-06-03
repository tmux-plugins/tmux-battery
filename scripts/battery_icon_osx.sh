#!/usr/bin/env bash

# script global variables
charged_icon=""
charging_icon=""
discharging_icon=""

charged_default="🔋 "
charging_default="⚡️ "
discharging_default=""

# tmux show-option "q" (quiet) flag does not set return value to 1, even though
# the option does not exist. This function patches that.
get_tmux_option() {
	local option=$1
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z $option_value ]; then
		return 1
	else
		echo $option_value
	fi
}

# icons are set as script global variables
get_icon_settings() {
	charged_icon=$(get_tmux_option "@batt_charged_icon" || echo "$charged_default")
	charging_icon=$(get_tmux_option "@batt_charging_icon" || echo "$charging_default")
	discharging_icon=$(get_tmux_option "@batt_discharging_icon" || echo "$discharging_default")
}

battery_status() {
	# "charged", "charging" or "discharging" is the 3rd field on the second line
	pmset -g batt | awk 'NR==2 { print $3 }'
}

print_icon() {
	local status=$1
	if [[ $status =~ (^charged) ]]; then
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
