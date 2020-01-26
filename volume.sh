#!/bin/bash

# Display volume
# uses PulseAudio, and pamixer

source "$(dirname $0)/helpers.sh"

# str containing {perc} and/or {icon} defining how stuff is displayed 
FORMAT="{icon} {vol}%"
apply_config_value "_format" "FORMAT"

VOLUME=$(pamixer --get-volume)
MUTE=$(pamixer --get-mute)

ICON_VOL_0=$(echo -e \\uf027)
ICON_VOL_1=$(echo -e \\uf028)
ICON_VOL_COUNT=2
ICON_VOL_OFF=$(echo -e \\uf026)
ICON_MUTE=$(echo -e \\uf6a9)

for n in $(seq 0 $ICON_VOL_COUNT); do
	apply_config_value "_icon_vol_$n" "ICON_VOL_$n"
done
apply_config_value "_icon_vol_off" "ICON_VOL_OFF"
apply_config_value "_icon_mute" "ICON_MUTE"


INDEX=$(scale_perc_to_level $VOLUME $ICON_VOL_COUNT)
ICON=$(get_value_by_index $INDEX "ICON_VOL_" '%s%d')

if [ "$VOLUME" = "0" ]; then ICON=$ICON_VOL_OFF; fi
if [ "$MUTE" = "true" ]; then ICON=$ICON_MUTE; fi

declare -A FIELDS
FIELDS["vol"]=$VOLUME
FIELDS["icon"]=$ICON
OUTPUT=$(format_output "$FORMAT")
pango_markup "$OUTPUT" "$(get_color_by_perc $VOLUME)"

