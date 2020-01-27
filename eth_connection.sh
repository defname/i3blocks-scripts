#!/bin/bash

# Output current WLAN SSID
# uses NetworkManager!
#
# variables that can be used in the i3blocks config file:
#     _icon_wifi, _icon_no_wifi, _icon_wifi_0, _icon_wifi_1, ..., icon_wifi_4,
#     _format, _format_no_connection, _use_signal_icons

source "$(dirname $0)/helpers.sh"

ICON_ETH=$(echo -e \\uf6ff)
ICON_NO_CONNECTION="X"

apply_config_value "_icon_eth" "ICON_ETH"
apply_config_value "_icon_no_connection" "ICON_NO_CONNECTION"

FORMAT_CONNECTION="{icon} {ip}"
FORMAT_NO_CONNECTION=""
apply_config_value "_format" "FORMAT_CONNECTION"
apply_config_value "_format_no_connection" "FORMAT_NO_CONNECTION"
FORMAT=$FORMAT_NO_CONNECTION

IFS=':' RAW=($(nmcli -t -f name,type,device connection show --active | grep ethernet))
CONN="${RAW[0]}"
COLOR=$(get_color_by_level "0")

declare -A FIELDS
FIELDS["ip"]="-disconnected-"
FIELDS["icon"]=$ICON_NO_CONNECTION

if [ -n "$CONN" ]; then
	IFS=' ' RAW=($(nmcli -t connection show "$CONN" | grep ip_address))
	FIELDS["ip"]=${RAW[-1]}
	FIELDS["icon"]=$ICON_ETH
	COLOR=$(get_color_by_level "10")
	FORMAT=$FORMAT_CONNECTION
fi


OUTPUT=$(format_output "$FORMAT")

pango_markup "$OUTPUT" "$COLOR"

exit 0
