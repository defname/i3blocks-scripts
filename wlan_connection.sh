#!/bin/bash

# Output current WLAN SSID
# uses NetworkManager!
#
# variables that can be used in the i3blocks config file:
#     _icon_wifi, _icon_no_wifi, _icon_wifi_0, _icon_wifi_1, ..., icon_wifi_4,
#     _format, _format_no_connection, _use_signal_icons

source "$(dirname $0)/helpers.sh"

ICON_WIFI=$(echo -e \\uf1eb)
ICON_NO_WIFI=$(echo -e \\ue933)
ICON_NO_WIFI_CONNECTION=$(echo -e \\ue934)
ICON_WIFI_0=$(echo -e \\ue93c)
ICON_WIFI_1=$(echo -e \\ue93a)
ICON_WIFI_2=$(echo -e \\ue938)
ICON_WIFI_3=$(echo -e \\ue936)
ICON_WIFI_COUNT=4

ICON_WIFI_SECURED_0=$(echo -e \\ue93b)
ICON_WIFI_SECURED_1=$(echo -e \\ue939)
ICON_WIFI_SECURED_2=$(echo -e \\ue937)
ICON_WIFI_SECURED_3=$(echo -e \\ue935)
ICON_WIFI_SECURED_COUNT=4


apply_config_value "_icon_wifi" "ICON_WIFI"
apply_config_value "_icon_no_wifi" "ICON_NO_WIFI"

apply_config_value "_icon_wifi_count" "ICON_WIFI_COUNT"
apply_config_value_array "_icon_wifi_" "ICON_WIFI_" "$ICON_WIFI_COUNT"

apply_config_value "_icon_wifi_secured_count" "ICON_WIFI_SECURED_COUNT"
apply_config_value_array "_icon_wifi_secured_" "ICON_WIFI_SECURED_" "$ICON_WIFI_SECUREDCOUNT"

WIFI_ENABLED="0"
SSID=""
SIGNAL="0"

# check if WIFI is generally enabled
if [ "$(nmcli -t -f wifi general status)" == "enabled" ]; then
    WIFI_ENABLED="1"
    RAW=$(nmcli -t -f active,ssid dev wifi | egrep '^ja')
    SSID=${RAW:3}
    RAW=$(nmcli -t -f active,signal dev wifi | egrep '^ja')
    SIGNAL=${RAW:3}
    RAW=$(nmcli -t -f active,security dev wifi | egrep '^ja')
    SECURE=${RAW:3}
fi

FORMAT="{icon} {ssid} {signal}%"
FORMAT_NO_CONNECTION="{icon}"
apply_config_value "_format" "FORMAT"
apply_config_value "_format_no_connection" "FORMAT_NO_CONNECTION"

declare -A FIELDS
FIELDS["ssid"]=$SSID
FIELDS["signal"]=$SIGNAL
FIELDS["icon"]=$ICON_WIFI

if [ "$WIFI_ENABLED" = "1" ]; then
    if [ -z "$SSID" ]; then
    	FORMAT=$FORMAT_NO_CONNECTION
    	FIELDS["ssid"]="-disconnected-"
    	FIELDS["signal"]="0"
    	FIELDS["icon"]=$ICON_NO_WIFI_CONNECTION
    else
        if [ -n $SECURE ]; then
            	FIELDS["icon"]=$(get_value_by_index $(scale_perc_to_level $SIGNAL $ICON_WIFI_COUNT) "ICON_WIFI_SECURED_" '%s%d')
        else
            FIELDS["icon"]=$(get_value_by_index $(scale_perc_to_level $SIGNAL $ICON_WIFI_COUNT) "ICON_WIFI_" '%s%d')
        fi
    fi
else
    FORMAT=$FORMAT_NO_CONNECTION
    FIELDS["ssid"]="n/a"
    FIELDS["signal"]="0"
    FIELDS["icon"]=$ICON_NO_WIFI
fi

FIELDS["color"]="$(get_color_by_perc $SIGNAL)"

echo "$(format_output "$FORMAT")"

exit 0

