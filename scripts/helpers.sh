# tmux show-option "q" (quiet) flag does not set return value to 1, even though
# the option does not exist. This function patches that.
#
# FIXME: this function differs from the one in ./battery.tmux file, even though
# they have the same name
get_tmux_option() {
	local option=$1
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z $option_value ]; then
		return 1
	else
		echo $option_value
	fi
}

is_osx() {
	[ $(uname) == "Darwin" ]
}

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}
