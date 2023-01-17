#!/bin/env bash

source "$(dirname $0)/helpers.sh"

FORMAT="{title}"
apply_config_value "_format" "FORMAT"

declare -A FIELDS

# takes the output of xprop as first argument and a property name
# like WM_NAME as second. Returns the value of the property or an empty string
function get_prop {
    XPROP=$1
    PROP_NAME=$2
    TEXT=$(echo "$XPROP" | grep -e "^$PROP_NAME.*= \".*\"$" | sed -e 's/^.* = "\(.*\)"$/\1/' | tr -d '\n')
    echo "$TEXT" | xargs
}

xtitle -s -f '%u\n' | while read ID; do
    XPROP="$(xprop -id $ID)"
    FIELDS["title"]=" "

    # try different properties where the window title is typically stored
    declare -a PROP_LIST=("NET_WM_NAME(STRING)" "WM_NAME(STRING)" "WM_NAME(UTF8_STRING)" "NET_ICON_NAME(STRING)" "NET_ICON_NAME(UTF8_STRING" "ICON_NAME" "CLASS")
    for PROP in "${PROP_LIST[@]}"; do
        value="$(get_prop "$XPROP" "$PROP")"
        # if property isn't empty use it as window title and stop searching
        if [[ -n "$value" ]]; then
            # escape special characters in window title
            value="$(echo "$value" | sed 's_&_&amp;_g; s_<_&lt;_g; s_>_&gt;_g;;')"
            value="${value//$'\n'/}"
            value="${value:0:250}"
            # value=$(printf "%q" "$value")
            FIELDS["title"]="$value"
            break;
        fi
    done

    # set empty output if no window title is found
    if [[ -z "${FIELDS['title']}" ]]; then
        FIELDS["title"]="###"
    fi


    #FIELDS["color"]="#999999"
	#style_output "$(format_output "$FORMAT")"
    format_output "$FORMAT"

done

exit


