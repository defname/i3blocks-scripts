#!/bin/bash

# Display volume
# uses PulseAudio, and pamixer

source "$(dirname $0)/helpers.sh"

# str containing {perc} and/or {icon} defining how stuff is displayed 
FORMAT="{icon} {vol}%"
apply_config_value "_format" "FORMAT"

# Query amixer for the current volume and whether or not the speaker is muted
#VOLUME="$(amixer -c 0 get Master | tail -1 | awk '{print $4}' | sed 's/[^0-9]*//g')"
#MUTE="$(amixer -c 0 get Master | tail -1 | awk '{print $6}' | sed 's/[^a-z]*//g')"
VOLUME=$(pamixer --get-volume)
MUTE=$(pamixer --get-mute)

ICON_VOL_0=$(echo -e \\ue92b)
ICON_VOL_1=$(echo -e \\ue92d)
ICON_VOL_2=$(echo -e \\ue930)
ICON_VOL_COUNT=3
ICON_VOL_OFF=$(echo -e \\ue92a)
ICON_MUTE=$(echo -e \\ue929)

apply_config_value "_icon_vol_count" "ICON_VOL_COUNT"
apply_config_value_array "_icon_vol_" "ICON_VOL_" "$ICON_VOL_COUNT"
apply_config_value "_icon_vol_off" "ICON_VOL_OFF"
apply_config_value "_icon_mute" "ICON_MUTE"


INDEX=$(scale_perc_to_level "$VOLUME" "$ICON_VOL_COUNT")
ICON=$(get_value_by_index "$INDEX" "ICON_VOL_" '%s%d')

if [ "$VOLUME" = "0" ]; then ICON=$ICON_VOL_OFF; fi
if [ "$MUTE" = "true" ]; then ICON=$ICON_MUTE; fi

declare -A FIELDS
FIELDS["vol"]="$VOLUME"
FIELDS["icon"]="$ICON"
FIELDS["color"]="$(get_color_by_perc $(echo "100-$VOLUME" | bc))"

style_output "$(format_output "$FORMAT")"

