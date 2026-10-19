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
	if [[ "$version" == *"Linux"* || "$version" == *"Microsoft"* || "$version" == *"microsoft"* ]]; then
		return 0
	else
		return 1
	fi
}

file_mtime() {
	stat -c %Y "$1" 2>/dev/null || stat -f %m "$1" 2>/dev/null
}

# Every attached tmux client runs the status scripts on each refresh, and each
# upower call is a new D-Bus client of upowerd. Cache upower's output for
# @batt_upower_cache_ttl seconds; 0 disables the cache.
cached_upower() {
	local ttl cache_dir cache mtime
	ttl=$(get_tmux_option "@batt_upower_cache_ttl" 15)
	if ! [ "$ttl" -gt 0 ] 2>/dev/null; then
		upower "$@"
		return
	fi

	cache_dir="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}"
	cache="${cache_dir%/}/tmux-battery-upower-$(id -u)-$(printf '%s' "$*" | tr -c 'A-Za-z0-9' '_')"
	if [ -f "$cache" ]; then
		mtime=$(file_mtime "$cache")
		if [ -n "$mtime" ] && [ $(( $(date +%s) - mtime )) -lt "$ttl" ]; then
			cat "$cache"
			return
		fi
	fi

	if upower "$@" > "$cache.$$"; then
		mv -f "$cache.$$" "$cache"
		cat "$cache"
	else
		rm -f "$cache.$$"
	fi
}

command_exists() {
	local command
	for command; do
		type "$command" >/dev/null 2>&1 || return $?
	done
}

battery_status() {
	if command_exists "pmset"; then
		pmset -g batt | awk -F '; *' 'NR==2 { print $2 }'
	elif command_exists "acpi"; then
		acpi -b | awk '{gsub(/,/, ""); print tolower($3); exit}'
	elif command_exists "upower"; then
		local battery
		battery=$(cached_upower -e | grep -E 'battery|DisplayDevice'| tail -n1)
		cached_upower -i $battery | awk '/state/ {print $2}'
	elif command_exists "apm"; then
		local battery
		battery=$(apm -a)
		if [ $battery -eq 0 ]; then
			echo "discharging"
		elif [ $battery -eq 1 ]; then
			echo "charging"
		fi
	elif command_exists "termux-battery-status" "jq"; then
		termux-battery-status | jq -er '.status | ascii_downcase'
	elif is_wsl; then
		local battery
		battery=$(find /sys/class/power_supply/*/status | tail -n1)
		awk '{print tolower($0);}' "$battery"
	fi
}

float2int() {
	local float="$1"
	if [[ $float =~ "," ]]; then
		echo ${float%,*}
	elif [[ $float =~ "." ]]; then
		echo ${float%.*}
	else
		echo ${float//%}
	fi
}
