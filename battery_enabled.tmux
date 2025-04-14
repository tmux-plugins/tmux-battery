#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

main() {
	tmux set-option -gq "@battery_exists" "$( [ -n "$(battery_status)" ] && echo true || echo false )"
}
main
