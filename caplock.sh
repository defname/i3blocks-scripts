#!/bin/env bash

# Display volume
# uses PulseAudio, and pamixer

source "$(dirname $0)/helpers.sh"

FORMAT="{text}"
ENABLED_CAPTION="CAPLOCK"
apply_config_value "_format" "FORMAT"
apply_config_value "_enabled_caption" "ENABLED_CAPTION"

echo $ENABLED_CAPTION >> /tmp/test
declare -A FIELDS
FIELDS["text"]=""
if [ -z "$(xset q | egrep -e 'Caps Lock:[[:space:]]*off')" ]; then
	FIELDS["text"]=$ENABLED_CAPTION
fi
FIELDS["color"]="$(get_color_by_perc 0)"
OUTPUT=$(format_output "$FORMAT")
style_output "$OUTPUT"

