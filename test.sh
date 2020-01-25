#!/bin/bash

source "$(dirname $0)/helpers.sh"

test_00="Test 0"
test_01="Test 1"
test_02="Test 2"
test_03="Test 3"


#apply_config_value "_perc" "perc"

lvl=$(scale_perc_to_level $_perc 11)

color=$(get_color_by_level $lvl)

pango_markup "$_perc% Level $lvl $color" $color 
exit 0
