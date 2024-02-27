get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value="$(tmux show-option -gqv "$option")"
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

is_osx() {
	[ $(uname) == "Darwin" ]
}

is_chrome() {
	chrome="/sys/class/chromeos/cros_ec"
	if [ -d "$chrome" ]; then
		return 0
	else
		return 1
	fi
}

is_wsl() {
	version=$(</proc/version)
	if [[ "$version" == *"Microsoft"* || "$version" == *"microsoft"* ]]; then
		return 0
	else
		return 1
	fi
}

command_exists() {
	local command
	for command; do
		type "$command" >/dev/null 2>&1
		(($? == 0)) || return $?
	done
}

battery_status() {
	if command_exists "termux-battery-status" "jq"; then
		termux-battery-status | jq -r '.status' | awk '{printf("%s%", tolower($1))}'
	elif is_wsl; then
		local battery
		battery=$(find /sys/class/power_supply/*/status | tail -n1)
		awk '{print tolower($0);}' "$battery"
	elif command_exists "pmset"; then
		pmset -g batt | awk -F '; *' 'NR==2 { print $2 }'
	elif command_exists "acpi"; then
		acpi -b | awk '{gsub(/,/, ""); print tolower($3); exit}'
	elif command_exists "upower"; then
		local battery
		battery=$(upower -e | grep -E 'battery|DisplayDevice'| tail -n1)
		upower -i $battery | awk '/state/ {print $2}'
	elif command_exists "apm"; then
		local battery
		battery=$(apm -a)
		if [ $battery -eq 0 ]; then
			echo "discharging"
		elif [ $battery -eq 1 ]; then
			echo "charging"
		fi
	fi
}
