#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

highlight_battery_percentage() {
	local battery_percentage="$1"
	local highlight_battery_color="$(get_tmux_option "@highlight_battery_color" "red")"
	local highlight_battery_threshold="$(get_tmux_option "@highlight_battery_threshold" 10)"

	if [[ $(echo "$battery_percentage" | sed 's/\%//') -le $highlight_battery_threshold ]]; then
		echo "#[fg=${highlight_battery_color}]${battery_percentage}#[fg=default]"
	else
		echo "$battery_percentage"
	fi
}

print_battery_percentage() {
	# percentage displayed in the 2nd field of the 2nd row
	if command_exists "pmset"; then
		pmset -g batt | awk 'NR==2 { gsub(/;/,""); print $2 }'
	elif command_exists "upower"; then
		for battery in $(upower -e | grep battery); do
			upower -i $battery | grep percentage | awk '{print $2}'
		done | xargs echo
	elif command_exists "acpi"; then
		acpi -b | grep -Eo "[0-9]+%"
	fi
}

main() {
	if [[ "$(get_tmux_option "@highlight_battery" "on")" == "on" ]]; then
		highlight_battery_percentage "$(print_battery_percentage)"
	else
		print_battery_percentage
	fi
}
main
