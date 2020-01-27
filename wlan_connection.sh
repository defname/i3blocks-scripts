#!/bin/bash

# Output current WLAN SSID
# uses NetworkManager!
#
# variables that can be used in the i3blocks config file:
#     _icon_wifi, _icon_no_wifi, _icon_wifi_0, _icon_wifi_1, ..., icon_wifi_4,
#     _format, _format_no_connection, _use_signal_icons

source "$(dirname $0)/helpers.sh"

ICON_WIFI=$(echo -e \\uf1eb)
ICON_NO_WIFI="X"
ICON_WIFI_0="____"
ICON_WIFI_1="▂___"
ICON_WIFI_2="▂▄__"
ICON_WIFI_3="▂▄▅_"
ICON_WIFI_4="▂▄▅▆"

for n in $(seq 0 4); do
	apply_config_value "_icon_wifi_$n" "ICON_WIFI_$n"
done
apply_config_value "_icon_wifi" "ICON_WIFI"
apply_config_value "_icon_no_wifi" "ICON_NO_WIFI"

#echo $(nmcli -t -f active,ssid,signal dev wifi | egrep '^ja')
RAW=$(nmcli -t -f active,ssid dev wifi | egrep '^ja')
SSID=${RAW:3}
RAW=$(nmcli -t -f active,signal dev wifi | egrep '^ja')
SIGNAL=${RAW:3}

FORMAT="{icon} {ssid} {signal}%"
FORMAT_NO_CONNECTION="{icon} {ssid}"
apply_config_value "_format" "FORMAT"
apply_config_value "_format_no_connection" "FORMAT_NO_CONNECTION"

declare -A FIELDS
FIELDS["ssid"]=$SSID
FIELDS["signal"]=$SIGNAL
FIELDS["icon"]=$ICON_WIFI

if [ -z "$SSID" ]; then
	FORMAT=$FORMAT_NO_CONNECTION
	FIELDS["ssid"]="-disconnected-"
	FIELDS["signal"]="0"
	FIELDS["icon"]=$ICON_NO_WIFI
else
	# use icons for signal strength if set in config
	if [ "$_use_signal_icons" == "1" ]; then
		FIELDS["icon"]=$(get_value_by_index $(scale_perc_to_level $SIGNAL 5) "ICON_WIFI_" '%s%d')
	fi
fi

OUTPUT=$(format_output "$FORMAT")

pango_markup "$OUTPUT" "$(get_color_by_perc $SIGNAL)"

exit 0
