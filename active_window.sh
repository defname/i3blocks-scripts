#!/bin/env bash

source "$(dirname $0)/helpers.sh"

FORMAT="{title}"
apply_config_value "_format" "FORMAT"

declare -A FIELDS
FIELDS["title"]=" "

xtitle -s -f '%u\n' | while read ID; do
	XPROP=$(xprop -id $ID)
	CLASS=$(echo "$XPROP" | grep 'WM_CLASS(STRING)' | sed -r 's/.*"(.*?)".*?/\1/')
    NAME=$(echo "$XPROP" | grep '_NET_WM_ICON_NAME(UTF8_STRING)')
    NAME=${NAME#*=\ \"}
    NAME=${NAME%\"}
	if [[ "$NAME" =~ ^_NET_WM_ICON_NAME\(UTF8_STRING\) ]]; then
		FIELDS["title"]="$CLASS"
	else
		FIELDS["title"]="$NAME"
	fi
    if [[ "${FIELDS["title"]}"=="" ]]; then
        FIELDS["title"]=" "
    fi
    FIELDS["color"]="#999999"
	style_output "$(format_output "$FORMAT")"
done 
