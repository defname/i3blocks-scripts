#!/bin/env bash

source "$(dirname $0)/helpers.sh"

UPDATE_COUNT=$(checkupdates | wc -l)
if [ "$UPDATE_COUNT" -gt "0" ]; then
    ICON=$(echo -e \\ue90c)
    FORMAT="{icon}"
    apply_config_value "_icon" "ICON"
    apply_config_value "_format" "FORMAT"
    declare -A FIELDS
    FIELDS["icon"]=$ICON
    FIELDS["count"]=$UPDATE_COUNT
    echo "$(format_output "$FORMAT")"
fi

exit 0

