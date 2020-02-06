#!/bin/sh

source "$(dirname $0)/helpers.sh"

weekday=$(date "+%A")
time=$(date "+%H:%M ")
date=$(date "+%d. %B")
#Das icon der Uhrzeit anpassen
hour=$(date "+%I")

ICON=$(echo -e \\ue903) 

FORMAT="{time}"
apply_config_value "_format" "FORMAT"

declare -A FIELDS
FIELDS["icon"]=$ICON
FIELDS["weekday"]=$weekday
FIELDS["date"]=$date
FIELDS["time"]=$time

echo $(format_output "$FORMAT")
exit 0

case $hour in
    00)  clkIcn="👻" #Buhuhu
        ;;
    01)  clkIcn="🕑"
        ;;
    02)  clkIcn="🕒"
        ;;
    03)  clkIcn="🕓"
        ;;
    04)  clkIcn="🕔"
        ;;
    05)  clkIcn="🕕"
        ;;
    06)  clkIcn="🕖"
        ;;
    07)  clkIcn="🕗"
        ;;
    08)  clkIcn="🕘"
        ;;
    09)  clkIcn="🕙"
        ;;
    10)  clkIcn="🕚"
        ;;
    11)  clkIcn="🕛"
        ;;
    12)  clkIcn="🕛"
        ;;
esac
echo "$clkIcn $time🗓 $weekday $day"
