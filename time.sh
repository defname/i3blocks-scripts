#!/bin/sh
weekday=$(date "+%A")
time=$(date "+%H:%M ")
day=$(date "+%d. %B")
#Das icon der Uhrzeit anpassen
hour=$(date "+%I")

if [ -z "$button" ]; then
	echo "$(echo -e \\uf017) $time"
	exit 0
fi
echo "$(echo -e \\uf783) $weekday $day"
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
