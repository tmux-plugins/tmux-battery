#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

battery_discharging() {
	local status="$(battery_status)"
	[[ $status =~ (discharging) ]]
}

pmset_battery_remaining_time() {
	local output="$(pmset -g batt | awk 'NR==2 { gsub(/;/,""); print $4 }')"
	# output has to match format "10:42"
	if [[ "$output" =~ ([[:digit:]]{1,2}:[[:digit:]]{2}) ]]; then
		printf "$output"
	fi
}

print_battery_remain() {
	if command_exists "pmset"; then
		pmset_battery_remaining_time
	elif command_exists "upower"; then
		battery=$(upower -e | grep battery | head -1)
    upower -i $battery | grep 'time to empty' | awk '{printf "- %s %s left", $4, $5}'
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
