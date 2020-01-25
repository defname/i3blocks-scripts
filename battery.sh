#!/bin/bash

# display the battery charge in i3blocks
# supported variables in i3blocks config file are
#     _bat	name of the battery (e.g. BAT1) [REQUIRED]
#     _format   a string containt {perc} and/or {icon} to define what to
#         	display (e.g. {perc}% {icon}) [Default: {perc}%]
#     _icon_bat_0, _icon_bat_1, ..., _icon_bat_4
#		icons for an empty battery (_icon_bat_0) up to a fully
#		charged battery (_icon_bat_4) [Default: font-awesome icons]
#     _icon_charging
#		an icon displayed when the battery is charging

if [ -z "$_bat" ]; then
	echo "bad config file: _BAT not set"
	exit 1
fi

source "$(dirname $0)/helpers.sh"

BAT=$_bat

# str containing {perc} and/or {icon} defining how stuff is displayed 
FORMAT="{perc}%"
apply_config_value "_format" "FORMAT"

NOW=$(cat /sys/class/power_supply/$BAT/energy_now)
FULL=$(cat /sys/class/power_supply/$BAT/energy_full)
STATUS=$(cat /sys/class/power_supply/$BAT/status)
PERC=$(bc <<< "100*$NOW/$FULL")

ICON_BAT_0=$(echo -e \\uf244)
ICON_BAT_1=$(echo -e \\uf243)
ICON_BAT_2=$(echo -e \\uf242)
ICON_BAT_3=$(echo -e \\uf241)
ICON_BAT_4=$(echo -e \\uf240)
ICON_CHARGING=$(echo -e \\uf1e6)

for n in $(seq 0 4); do
	apply_config_value "_icon_bat_$n" "ICON_BAT_$n"
done
apply_config_value "_icon_charging" "ICON_CHARGING"

INDEX=$(scale_perc_to_level $PERC 5)
ICON=$(get_value_by_index $INDEX "ICON_BAT_" '%s%d')
if [ "$STATUS" = "Charging" ]; then ICON=$ICON_CHARGING; fi

declare -A FIELDS
FIELDS["perc"]=$PERC
FIELDS["icon"]=$ICON
OUTPUT=$(format_output "$FORMAT")
pango_markup "$OUTPUT" "$(get_color_by_perc $PERC)"

