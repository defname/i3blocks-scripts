#!/bin/bash

# Display brightness
# uses brightnessctl

source "$(dirname $0)/helpers.sh"

# str containing {perc} and/or {icon} defining how stuff is displayed 
FORMAT="{icon} {brightness}%"
apply_config_value "_format" "FORMAT"

RAW=($(brightnessctl -m | tr "," "\n"))
BRIGHTNESS=${RAW[3]::-1} # delete lasst character "%"
#echo $(generate_progress_bar "$BRIGHTNESS")

ICON=$(echo -e \\ue90a)
apply_config_value "_icon" "ICON"

declare -A FIELDS
FIELDS["brightness"]=$BRIGHTNESS
FIELDS["icon"]=$ICON
FIELDS["color"]=$(get_color_by_perc $(echo "100-$BRIGHTNESS" | bc))

style_output "$(format_output "$FORMAT")"

