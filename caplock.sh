#!/bin/env bash

# Display volume
# uses PulseAudio, and pamixer

source "$(dirname $0)/helpers.sh"

# str containing {perc} and/or {icon} defining how stuff is displayed 
FORMAT="{text}"
ENABLED_CAPTION="CAPLOCK"
apply_config_value "_format" "FORMAT"
apply_config_value "_enabled_caption" "ENABLED_CAPTION"

declare -A FIELDS
FIELDS["text"]=""
if [ -z $(xset q | egrep -e 'Caps Lock:[[:space:]]*off') ]; then
	FIELDS["text"]=$ENABLED_CAPTION
fi
OUTPUT=$(format_output "$FORMAT")
pango_markup "$OUTPUT" "$(get_color_by_perc 0)"

