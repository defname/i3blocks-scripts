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
    TEXT=$(echo "$XPROP" | grep -e ".*$PROP_NAME.*= \".*\"" | sed -e 's/^.* = .*"\(.*\)"$/\1/' | tr -d '\n')
    echo "$TEXT"
}

xtitle -s -f '%u\n' | while read ID; do
    XPROP=$(xprop -id $ID)
    FIELDS["title"]=" "

    # try different properties where the window title is typically stored
    declare -a PROP_LIST=("NET_WM_NAME" "WM_NAME" "NET_ICON_NAME" "ICON_NAME" "CLASS")
    for PROP in "${PROP_LIST[@]}"; do
        value="$(get_prop "$XPROP" "$PROP")"
#DEBUG
        # DEBUG
        # echo "$PROP -> ${FIELDS["title"]}"  >> /tmp/test
        if [[ -n "$value" ]]; then
            FIELDS["title"]="$value"
            break;
        fi
    done

    if [[ -z "${FIELDS['title']}" ]]; then
        FIELDS["title"]=" "
    fi
    #FIELDS["color"]="#999999"
	#style_output "$(format_output "$FORMAT")"
    format_output "$FORMAT"

done

exit


xtitle -s -f '%u\n' | while read ID; do
	XPROP=$(xprop -id $ID)
	CLASS=$(echo "$XPROP" | grep 'WM_CLASS(STRING)' | sed -r 's/.*"(.*?)".*?/\1/')
    ICON_NAME=$(echo "$XPROP" | grep '_NET_WM_ICON_NAME(UTF8_STRING)')
    ICON_NAME=${ICON_NAME#*=\ \"}
    ICON_NAME=${ICON_NAME%\"}
    NAME=$(echo "$XPROP" | grep 'WM_NAME')
    echo "$ICON_NAME --- $NAME" >> /tmp/test
	
    if [[ "$ICON_NAME" =~ ^_NET_WM_ICON_NAME\(UTF8_STRING\) ]]; then
		FIELDS["title"]="$CLASS"
	else
		FIELDS["title"]="$ICON_NAME"
	fi

    if [[ -z "${FIELDS['title']}" ]]; then
        FIELDS["title"]="$NAME"
    fi

    if [[ -z "${FIELDS['title']}" ]]; then
        FIELDS["title"]=" "
    fi
    FIELDS["title"]="${FIELDS["title"]}"
    #FIELDS["color"]="#999999"
	#style_output "$(format_output "$FORMAT")"
    format_output "$FORMAT"
done 
