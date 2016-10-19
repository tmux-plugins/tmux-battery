#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_battery_percentage() {
	# percentage displayed in the 2nd field of the 2nd row
	if command_exists "pmset"; then
		pmset -g batt | grep -o "[0-9]\{1,3\}%"
	elif command_exists "upower"; then
		local batteries=( $(upower -e | grep battery) )
		local energy
		local energy_full
		for battery in ${batteries[@]}; do
			energy=$(upower -i $battery | awk -v nrg="$energy" '/energy:/ {print nrg+$2}')
			energy_full=$(upower -i $battery | awk -v nrgfull="$energy_full" '/energy-full:/ {print nrgfull+$2}')
		done
		echo $energy $energy_full | awk '{printf("%d%%", ($1/$2)*100)}'
	elif command_exists "acpi"; then
		acpi -b | grep -Eo "[0-9]+%"
	fi
}

main() {
	print_battery_percentage
}
main
