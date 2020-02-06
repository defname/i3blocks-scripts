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

ICON_BAT_0=$(echo -e \\ue901)
ICON_BAT_1=$(echo -e \\ue906)
ICON_BAT_2=$(echo -e \\ue90d)
ICON_BAT_3=$(echo -e \\ue910)
ICON_BAT_4=$(echo -e \\ue912)
ICON_BAT_5=$(echo -e \\ue914)
ICON_BAT_6=$(echo -e \\ue916)
ICON_BAT_7=$(echo -e \\ue918)
ICON_BAT_8=$(echo -e \\ue922)
ICON_BAT_9=$(echo -e \\ue924)
ICON_BAT_COUNT=10

ICON_BAT_CHARGING_0=$(echo -e \\ue900)
ICON_BAT_CHARGING_1=$(echo -e \\ue902)
ICON_BAT_CHARGING_2=$(echo -e \\ue909)
ICON_BAT_CHARGING_3=$(echo -e \\ue911)
ICON_BAT_CHARGING_4=$(echo -e \\ue913)
ICON_BAT_CHARGING_5=$(echo -e \\ue915)
ICON_BAT_CHARGING_6=$(echo -e \\ue917)
ICON_BAT_CHARGING_7=$(echo -e \\ue919)
ICON_BAT_CHARGING_8=$(echo -e \\ue91e)
ICON_BAT_CHARGING_9=$(echo -e \\ue923)
ICON_BAT_CHARGING_COUNT=10


apply_config_value "_icon_bat_count" "ICON_BAT_COUNT"
apply_config_value_array "_icon_bat_" "ICON_BAT_" "$ICON_BAT_COUNT"
apply_config_value_array "_icon_charging_" "ICON_CHARGING_" "$ICON_BAT_CHARGING_COUNT"

INDEX=$(scale_perc_to_level "$PERC" "$ICON_BAT_COUNT")
ICON=$(get_value_by_index "$INDEX" "ICON_BAT_" '%s%d')
if [ "$STATUS" = "Charging" ]; then
    INDEX=$(scale_perc_to_level "$PERC" "$ICON_BAT_CHARGING_COUNT")
    ICON=$(get_value_by_index "$INDEX" "ICON_BAT_CHARGING_" '%s%d')
fi

declare -A FIELDS
FIELDS["perc"]=$PERC
FIELDS["icon"]=$ICON
FIELDS["color"]=$(get_color_by_perc "$PERC")
echo $(format_output "$FORMAT")

exit 0
