#!/bin/env bash

source "$(dirname $0)/helpers.sh"

CRITICAL_COUNT=50
UPDATE_COUNT=$(checkupdates | wc -l)
if [ "$UPDATE_COUNT" -gt "0" ]; then
    ICON=$(echo -e \\ue90c)
    FORMAT="{icon}"
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
    style_output "$(format_output "$FORMAT")"
fi

exit 0

