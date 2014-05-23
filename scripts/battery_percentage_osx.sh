#!/usr/bin/env bash

print_battery_percentage() {
    # percentage displayed in the 2nd field of the 2nd row
    pmset -g batt | awk 'NR==2 { gsub(/;/,""); print $2 }'
}

main() {
    print_battery_percentage
}
main
