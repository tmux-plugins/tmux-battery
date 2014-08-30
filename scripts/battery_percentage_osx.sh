#!/usr/bin/env bash

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}

print_battery_percentage() {
	# percentage displayed in the 2nd field of the 2nd row
	if command_exists "pmset"; then
		pmset -g batt | awk 'NR==2 { gsub(/;/,""); print $2 }'
	elif command_exists "upower"; then
		battery=$(upower -e | grep battery | head -1)
		upower -i $battery | grep percentage | awk '{print $2}'
	fi
}

main() {
	print_battery_percentage
}
main
