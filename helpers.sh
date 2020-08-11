#/bin/env bash

# default values

color00="#E99393"
color01="#E3A192"
color02="#DDB091"
color03="#D7BE91"
color04="#D1CD90"
color05="#CCDC90"
color06="#BED390"
color07="#B0CA90"
color08="#A3C190"
color09="#95B890"
color10="#88B090"

# for later use
# ▁▂▃▄▅▆▇█

# use dots instead of commas, that caused errors with printf
LC_NUMERIC="en_US.UTF-8"

function powerline_style {
    #local str="<sup><span size='medium'>$1</span></sup>"
    local str="$1"
    local repair_str=""
    
    if [ -n "$_powerline_color" ]; then
        if [ -n "$_powerline_color_left" ] && [ -n "$_powerline_symbol_left" ]; then
            printf "<span$repair_str background='%s' foreground='%s'>%s</span>" "$_powerline_color_left" "$_powerline_color" "$_powerline_symbol_left"
        fi
        printf "<span$repair_str background='%s'>%s" "$_powerline_color" "$str"
        if [ -n "$_powerline_color_right" ] && [ -n "$_powerline_symbol_right" ]; then
            printf "<span foreground='%s'>%s</span>" "$_powerline_color_right" "$_powerline_symbol_right"
        fi
        printf "</span>\n"
    else
        echo "$str"
    fi
}

function style_output {
    local str="$1"
    powerline_style "$str"
}
# colorize text with mango markup ($markup is a global variable, set by
# i3blocks and can be configured in the i3blocks configuration file)
#
# Arguments: text, color
function pango_markup {
	if [ $# -ne 2 ]; then echo "pango_markup" && exit 1; fi
	local str=$1
	local color=$2
	if [ -n "$str" ]; then
		if [ "$markup" != "pango" ]; then
			echo $str
		else
			powerline_style "<span foreground=\"$color\">$str</span>"
		fi
	fi
}

# test if a global variable is set and if so apply it to another (local) one
# Arguments:
#    global_varname: name of the global variable
#    intern_varname: name of the internal variable
# give variable names without '$' in the beginning!
function apply_config_value {
	local global_varname=$1
	local intern_varname=$2

	if [ -n "$(eval "echo \$$global_varname")" ]; then
		eval "$intern_varname=\$$global_varname"
	fi
}

function apply_config_value_array {
    local global_varname="$1"
    local intern_varname="$2"
    local count="$3"
    local number_format="%d"

    if [ -n "$4" ]; then
        number_format="$4"
    fi
        
    for n in $(seq 0 $(echo "$count-1" | bc)); do
        apply_config_value "$(printf "%s$number_format" "$global_varname" "$n")" "$(printf "%s$number_format" "$intern_varname" "$n")"
    done
}

# Put the content in the formats string
# The associative array FIELDS need to be filled before calling this function
# The function takes a string with placeholder between "{" and "}" which
# are replaced by the content in the array
# E.g.
#     declare -A FIELDS
#     FIELDS["phone"]="123456"
#     FIELDS["name"]="Peter"
#     format_output "{name} -> {phone}"
#     -> "Peter -> 123456"
function format_output {
	output=$1
	for k in ${!FIELDS[@]}; do
		output=${output/\{$k\}/${FIELDS[$k]}}
	done
	echo "$output"
}


# get the symbol associated with a particular level e.g. there are
# variables symbol01="a", symbol02="b", symbol03="c, symbol04="d" defined in i3blocks
# configuration or somewhere in the script 
#    get_value_by_level 3 "symbol"
# prints "c"
function get_value_by_index {
	index=$1
	varname=$2
	format='%s%d'
	if [ -n "$3" ]; then format=$3; fi
	
	echo "$(eval "echo \$$(printf $format $varname $index)")"
}


function scale_perc_to_level {
	perc=$1
	levels_count=$2
	# +0.5 and cut at decimal point to round to integer
	level=$(printf "%.2f" $(echo "scale=2;($perc*($levels_count-1)/100)+0.5" | bc))
	echo ${level/\.*/}
}

# print the color associated with given level between 0 an 10 (including)
#
# Arguments: level
function get_color_by_level {
	level="$1"
	get_value_by_index "$level" "color" '%s%02d'
}

function get_color_by_perc {
	perc=$1
	if [ "$perc" -gt "100" ]; then perc="100"; fi 
	get_color_by_level "$(scale_perc_to_level $perc 11)"
}

function generate_progress_bar {
	perc=$1
	OUT=""
	for n in $(seq 10 10 100); do
		if [ "$n" -le "$perc" ]; then
			OUT="$OUT█"
		else
			OUT="$OUT░"
		fi
	done
	echo "$OUT"
}

function generate_gauge {
	level=$(scale_perc_to_level $1 8)
	diff=$(bc <<< "7-$level")
	gauge="▁▂▃▄▅▆▇█"
	empty="▁▁▁▁▁▁▁▁"
	out="${gauge:0:$level}${empty:0:$diff}"
	echo $out
}

# apply the i3blocks config
apply_config_value_array '_color' 'color' 11 '%02d'

# put own definitions from i3blocks config in CONFIG variable

