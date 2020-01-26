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

# colorize text with mango markup ($markup is a global variable, set by
# i3blocks and can be configured in the i3blocks configuration file)
#
# Arguments: text, color
function pango_markup {
	if [ $# -ne 2 ]; then echo "pango_markup" && exit 1; fi
	local str=$1
	local color=$2
	if [ "$markup" != "pango" ]; then
		echo $str
	else
		echo "<span color=\"$color\">$str</span>"
	fi
}	

# test if a global variable is set and if so apply it to another (local) one
# Arguments:
#    global_varname: name of the global variable
#    intern_varname: name of the internal variable
# give variable names without '$' in the beginning!
function apply_config_value {
	global_varname=$1
	intern_varname=$2
	
	if [ -n "$(eval "echo \$$global_varname")" ]; then
		eval "$intern_varname=\$$global_varname"
	fi
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
	level=$(printf "%.0f" $(echo "scale=2;($perc*($levels_count-1)/100)+0.5" | bc))
	echo $level
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
	if [ $perc -gt 100 ]; then perc=100; fi 
	get_color_by_level $(scale_perc_to_level $perc 11)
}


# apply the i3blocks config
for n in $(seq 0 10); do
	apply_config_value $(printf '_color%02d' $n) $(printf 'color%02d' $n)
done

