#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_battery_status_bg() {
	# percentage displayed in the 2nd field of the 2nd row
	if command_exists "pmset"; then
		percentage=$(pmset -g batt | awk 'NR==2 { gsub(/;/,""); print $2 }')
	elif command_exists "upower"; then
		for battery in $(upower -e | grep battery); do
			upower -i $battery | grep percentage | awk '{print $2}'
		done | xargs echo
	elif command_exists "acpi"; then
		percentage=$(acpi -b | grep -Eo "[0-9]+%")
	fi
    percentage=$(echo $percentage | sed -e 's/%//')
    if [ $percentage -eq 100 ]; then
        echo "#[bg=green]"
    elif [ $percentage -le 99 -a $percentage -ge 51 ];then
        echo "#[bg=yellow]"
    elif [ $percentage -le 50 -a $percentage -ge 16 ];then
        echo "#[bg=colour208]" # orange
    else
        echo "#[bg=red]"
    fi
}

main() {
	print_battery_status_bg
}
main
