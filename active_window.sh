#!/bin/env bash

source "$(dirname $0)/helpers.sh"

FORMAT="{title}"
apply_config_value "_format" "FORMAT"

declare -A FIELDS

xtitle -s -f '%u\n' | while read ID; do
	XPROP=$(xprop -id $ID)
	CLASS=$(echo "$XPROP" | grep 'WM_CLASS(STRING)' | sed -r 's/.*"(.*?)".*?/\1/')
	NAME=$(echo "$XPROP" | grep '_NET_WM_ICON_NAME(UTF8_STRING)' | egrep -e '.*"(.*?)".*?'| sed -r 's/.*"(.*?)".*?/\1/')
	if [ -z "$NAME" ]; then
		FIELDS["title"]="$CLASS"
	else
		FIELDS["title"]="$NAME"
	fi
	OUTPUT=$(format_output "$FORMAT")
	pango_markup "$OUTPUT" "$(get_color_by_perc 100)"
done 
