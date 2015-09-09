#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# script global variables
crit_value=""
warn_value=""

crit_prefix=""
warn_prefix=""
ok_prefix=""

# default values
crit_value_default="10"
warn_value_default="30"

crit_prefix_default="#[fg=red]"
warn_prefix_default="#[fg=yellow]"
ok_prefix_default="#[fg=green]"

# get settings from tmux config
get_thresh_settings() {
	crit_value=$(get_tmux_option "@batt_crit_thresh" "$crit_value_default")
	warn_value=$(get_tmux_option "@batt_warn_thresh" "$warn_value_default")

	crit_prefix=$(get_tmux_option "@batt_crit_prefix" "$crit_prefix_default")
	warn_prefix=$(get_tmux_option "@batt_warn_prefix" "$warn_prefix_default")
	ok_prefix=$(get_tmux_option "@batt_ok_prefix" "$ok_prefix_default")
}

print_thresholds() {
	if [ "$1" -lt "$crit_value" ]; then
		echo "$crit_prefix"
	elif [ "$1" -lt "$warn_value" ]; then
		echo "$warn_prefix"
	else
		echo "$ok_prefix"
	fi
}

main() {
	get_thresh_settings
	local percentage=$($CURRENT_DIR/battery_percentage.sh)
	print_thresholds ${percentage%?}
}
main
