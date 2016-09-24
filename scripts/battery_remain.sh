#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

battery_discharging() {
	local status="$(battery_status)"
	[[ $status =~ (discharging) ]]
}

pmset_battery_remaining_time() {
	pmset -g batt | grep -o '[0-9]\{1,2\}:[0-9]\{1,2\}'
}

print_battery_remain() {
	if command_exists "pmset"; then
		pmset_battery_remaining_time
	elif command_exists "upower"; then
		battery=$(upower -e | grep battery | head -1)
		upower -i $battery | grep remain | awk '{print $4}'
	elif command_exists "acpi"; then
		acpi -b | grep -Eo "[0-9]+:[0-9]+:[0-9]+"
	fi
}

main() {
	if battery_discharging; then
		print_battery_remain
	fi
}
main
