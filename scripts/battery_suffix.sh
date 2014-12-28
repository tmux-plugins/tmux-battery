#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# script global variables
crit_value=""
warn_value=""

crit_suffix=""
warn_suffix=""
ok_suffix=""

# default values
crit_value_default="10"
warn_value_default="30"

crit_suffix_default="#[fg=default]"
warn_suffix_default="#[fg=default]"
ok_suffix_default="#[fg=default]"

# get settings from tmux config
get_thresh_settings() {
	crit_value=$(get_tmux_option "@batt_crit_thresh" "$crit_value_default")
	warn_value=$(get_tmux_option "@batt_warn_thresh" "$warn_value_default")

	crit_suffix=$(get_tmux_option "@batt_crit_suffix" "$crit_suffix_default")
	warn_suffix=$(get_tmux_option "@batt_warn_suffix" "$warn_suffix_default")
	ok_suffix=$(get_tmux_option "@batt_ok_suffix" "$ok_suffix_default")
}

print_thresholds() {
	if [ "$1" -lt "$crit_value" ]; then
		echo $crit_suffix
	elif [ "$1" -lt "$warn_value" ]; then
		echo $warn_suffix
	else
		echo $ok_suffix
	fi
}

main() {
	get_thresh_settings
	local percentage=$($CURRENT_DIR/battery_percentage.sh)
	print_thresholds ${percentage%?}
}
main
