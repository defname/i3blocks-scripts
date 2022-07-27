#!/bin/env bash

source "$(dirname $0)/helpers.sh"

# Standard-/fallback configuration
ICON=$(echo -e \\ue90c)
FORMAT="{icon}"

CRITICAL_COUNT=50
UPDATE_COUNT=$(checkupdates | wc -l)  # get the number of updates available

# exit if no updates available
if [[ -z "$UPDATE_COUNT" ]]; then  # sometimes things go wrong... 
    exit 0
fi
if [ "$UPDATE_COUNT" -le "0" ]; then
    exit 0
fi

# othwise....
# use config from i3blocks configuration
apply_config_value "_icon" "ICON"
apply_config_value "_format" "FORMAT"
declare -A FIELDS
FIELDS["icon"]=$ICON
FIELDS["count"]=$UPDATE_COUNT

 # calculate color by UPDATE_COUNT
if [ "$UPDATE_COUNT" -gt "$CRITICAL_COUNT" ]; then
    FIELDS["color"]=$(get_color_by_perc "0")
else
    CRITICAL_PERC=$(echo "100-$UPDATE_COUNT*100/$CRITICAL_COUNT" | bc )
    FIELDS["color"]=$(get_color_by_perc $CRITICAL_PERC)
fi

# print output
style_output "$(format_output "$FORMAT")"

exit 0

