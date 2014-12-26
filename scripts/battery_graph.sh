#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_sparkline() {
    spark 0 $1 100 | awk '{print substr($0,4,3)}'
}

main() {
    local percentage=$($CURRENT_DIR/battery_percentage.sh)
    print_sparkline ${percentage%?}
}
main
