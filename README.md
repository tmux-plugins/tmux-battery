# Tmux battery status

Enables displaying battery percentage and status icon in tmux status-right.

Battery full (for OS X):<br/>
![battery full](/screenshots/battery_full.png)

Battery discharging, custom discharge icon:<br/>
![battery discharging, custom icon](/screenshots/battery_discharging.png)

Battery charging:<br/>
![battery charging](/screenshots/battery_charging.png)

Battery remain:<br/>
![battery remain](/screenshots/battery_remain.png)

Battery fully charged:<br/>
![battery_status_bg_green](/screenshots/battery_status_bg_green.png)

Battery between 99% and 51% charged:<br/>
![battery_status_bg_yellow](/screenshots/battery_status_bg_yellow.png)

Battery between 50% and 16% charged:<br/>
![battery_status_bg_orange](/screenshots/battery_status_bg_orange.png)

Battery between 15% and dead:<br/>
![battery_status_bg_red](/screenshots/battery_status_bg_red.png)

This is done by introducing 4 new format strings that can be added to
`status-right` option:
- `#{battery_icon}` - will display a battery status icon
- `#{battery_percentage}` - will show battery percentage
- `#{battery_remain}` - will show remaining time of battery charge
- `#{battery_status_bg}` - will set the background color of the status bar based on battery percentage
- `#{battery_graph}` - will show battery percentage as a bar graph ▁▂▃▅▇

### Usage

Add `#{battery_icon}`, `#{battery_percentage}` `#{battery_remain}`, or
`#{battery_status_bg}` format strings to existing `status-right` tmux option.
Example:

    # in .tmux.conf
    set -g status-right '#{battery_status_bg} Batt: #{battery_icon} #{battery_percentage} #{battery_remain} | %a %h-%d %H:%M '

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'tmux-plugins/tmux-battery'

Hit `prefix + I` to fetch the plugin and source it.

If format strings are added to `status-right`, they should now be visible.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/tmux-plugins/tmux-battery ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/battery.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

If format strings are added to `status-right`, they should now be visible.

### Changing icons

By default, these icons are displayed:

 - charged: ":battery:" ("❇ " when not on OS X)
 - charging: ":zap:"
 - discharging: (nothing shown)
 - attached but not charging: ":warning:"

You can change these defaults by adding the following to `.tmux.conf` (the
following lines are not in the code block so that emojis can be seen):

 - set -g @batt_charged_icon ":sunglasses:"
 - set -g @batt_charging_icon ":+1:"
 - set -g @batt_discharging_icon ":thumbsdown:"
 - set -g @batt_attached_icon ":neutral_face:"

Don't forget to reload tmux environment (`$ tmux source-file ~/.tmux.conf`)
after you do this.

### Limitations

- Battery icon change most likely won't be instant.<br/>
  When you un-plug power cord it will take some time (15 - 60 seconds) for the
  icon to change. This depends on the `status-interval` tmux option. Setting it
  to 15 seconds should be good enough.

### Other goodies

You might also find these useful:

- [resurrect](https://github.com/tmux-plugins/tmux-resurrect) - restore tmux
  environment after system restart
- [logging](https://github.com/tmux-plugins/tmux-logging) - easy logging and
  screen capturing
- [online status](https://github.com/tmux-plugins/tmux-online-status) - online status
  indicator in tmux `status-right`. Useful when on flaky connection to see if
  you're online.

You might want to follow [@brunosutic](https://twitter.com/brunosutic) on
twitter if you want to hear about new tmux plugins or feature updates.

### Contributors

- [@jgeralnik](https://github.com/jgeralnik)
- [@m1foley](https://github.com/m1foley)
- [@asethwright](https://github.com/asethwright)
- [@JanAhrens](https://github.com/JanAhrens)
- [@martinbeentjes](https://github.com/martinbeentjes)

### License

[MIT](LICENSE.md)
