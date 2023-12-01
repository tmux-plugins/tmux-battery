#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_battery_percentage() {
	if is_osx; then
		watts=$(system_profiler SPPowerDataType | grep Wattage | awk '{print $3}')
		if [ -z $watts];
		then
		    watts="0"
		fi
		echo "$watts"
	else 
		echo "??"
	fi
}

main() {
	print_battery_percentage
}
main
