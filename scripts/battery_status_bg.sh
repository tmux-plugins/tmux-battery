#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_battery_status_bg() {
    # Call `battery_percentage.sh`.
    percentage=$($CURRENT_DIR/battery_percentage.sh | sed -e 's/%//')
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
