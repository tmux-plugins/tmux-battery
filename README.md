# Tmux battery status for OSX

Enables displaying battery percentage and status icon in Tmux status-right.

Battery full:<br/>
![battery full](/screenshots/battery_full.png)

Battery discharging, custom discharge icon:<br/>
![battery discharging, custom icon](/screenshots/battery_discharging.png)

Battery charging:<br/>
![battery charging](/screenshots/battery_charging.png)

This is done by introducing 2 new format strings that can be added to
`status-right` option:
- `#{battery_icon}` - will display a battery status icon
- `#{battery_percentage}` - will show battery percentage

### Usage

Add `#{battery_icon}` or `#{battery_percentage}` format strings to existing
`status-right` Tmux option.

Example:

    set -g status-right "Batt: #{battery_icon} #{battery_percentage} | %a %h-%d %H:%M "

### Installation with [Tmux Plugin Manager](https://github.com/bruno-/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @tpm_plugins "              \
      bruno-/tpm                       \
      bruno-/tmux_battery_osx          \
    "

Hit `prefix + I` to fetch the plugin and source it.

If format strings are added to `status-right`, they should now be visible.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/bruno-/tmux_battery_osx ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/battery_osx.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

If format strings are added to `status-right`, they should now be visible.

### Changing icons

By default, these icons are displayed:

 - charged: ":battery:"
 - charging: ":zap:"
 - discharging: (nothing shown)

You can change these defaults by adding the following to `.tmux.conf` (the
following lines are not in the code block so that emojis can be seen):

 - set-option -g @batt_charged_icon ":sunglasses:"
 - set-option -g @batt_charging_icon ":+1:"
 - set-option -g @batt_discharging_icon ":thumbsdown:"

Reminder: OSX allows you to insert various emojis by pressing `Cmd+Ctrl+Space`.

Don't forget to reload TMUX environment (`$ tmux source-file ~/.tmux.conf`)
after you do this.

### Known issues

- Battery icon change most likely won't be instant.<br/>
  For example, when you un-plug power cord it will take some time (15 - 60
  seconds) for the icon to change. This depends on the `status-interval` TMUX
  option. Setting it to 15 seconds should be good enough.

### Other plugins

You might also find these useful:

- [pain control](https://github.com/bruno-/tmux_pain_control) - useful standard
  bindings for controlling panes
- [goto session](https://github.com/bruno-/tmux_goto_session) - faster session
  switching
- [logging](https://github.com/bruno-/tmux_logging) - easy logging and
  screen capturing
- [online status](https://github.com/bruno-/tmux_online_status) - online status
  indicator in Tmux `status-right`. Useful when on flaky connection to see if
  you're online.

### License

[MIT](LICENSE.md)
