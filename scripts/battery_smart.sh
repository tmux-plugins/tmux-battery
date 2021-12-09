#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/battery_icon_status.sh"  > /dev/null
source "$CURRENT_DIR/battery_percentage.sh"  > /dev/null
source "$CURRENT_DIR/battery_color_charge.sh" > /dev/null
source "$CURRENT_DIR/battery_remain.sh" > /dev/null
short=false


main() {
    #get_icon_status_settings
    local color_bg
    local percentage
    local status
    local icon_status
    local remain
    
    color_bg="$(print_color_charge bg)"
    percentage=$($CURRENT_DIR/battery_percentage.sh | sed -e 's/%//')
    status=$(battery_status)
    icon_status=$(print_icon_status "$status")
    get_remain_settings
    remain=$(print_battery_remain)

    if [ "$status" != "discharging" ] && [ $percentage -gt 98 ]; then
        # If almost full or better and plugged in, we do not need to see
        # details about battery. An icon indicating power is plugged in,
        # should be enough
        printf "$icon_status"
    else
        printf "${color_bg} $icon_status ${percentage} ${remain} #[default]"
    fi
}

main
