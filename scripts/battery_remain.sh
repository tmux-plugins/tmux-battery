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
		if is_chrome; then
			if battery_discharging; then
				upower -i $battery | grep 'time to empty' | awk '{printf "- %s %s left", $4, $5}'
			else
				upower -i $battery | grep 'time to full' | awk '{printf "- %s %s till full", $4, $5}'
			fi
		else
			upower -i $battery | grep -E '(remain|time to empty)' | awk '{print $(NF-1)}'
		fi
	elif command_exists "acpi"; then
		acpi -b | grep -Eo "[0-9]+:[0-9]+:[0-9]+"
	fi
}

print_battery_full() {
	if command_exists "upower"; then
		battery=$(upower -e | grep battery | head -1)
		upower -i $battery | grep 'time to full' | awk '{printf "- %s %s till full", $4, $5}'
	fi
}

main() {
	if battery_discharging; then
		print_battery_remain
	else
		print_battery_full
	fi
}
main
