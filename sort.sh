#!/bin/env bash

reverse=false

help(){
    printf "\n\033[1;31m%s \033[1;33m%s \033[0m%s\n\n" \
			"Usage:" "sort" "{ options } { data to be sorted }"
	printf "\033[1;33m%s\033[1;32m%s\n\033[1;33m%s\033[1;32m%s\n%s" \
							"-r, --reverse:" "Reverses the order of sort process" \
							"-t, --text:"    "This flag must be enabled to handle strings. Otherwise " \
											 ":arguments will be considered numeric as it is the default"  | column -t -s ":" -T 1
	printf "\n\n\033[1;31m%s%s%s\033[0m\n\n" "Arguments are expected as the last parameter unless " \
											 "text sorting is specified. If it is, then arguments " \
											 "must come after the flag."
}
sort_number(){
	num_array=("$@")
	len=${#num_array[@]}
	for (( digit=0; digit < 2**62; digit++ )); {
		for num in ${num_array[@]}; {
			(( 10#$num == digit )) && {
				(( counter++ ))
				{ $reverse; } && sorted="${num} $sorted" \
							  || sorted+="${num} "
			} 
		(( counter == len )) && printf "${sorted[@]}\n" && exit
		}
	}
}

sort_string(){
	string_array=("$@")
	for (( index=0; index < ${#string_array[@]}; index++ )); {
		for (( iter=0; iter < ${#string_array[@]}; iter++ )); {
			if [[ ${string_array[index]} > ${string_array[iter]} ]]; then
				(( counter++ ))
			fi
		}
		sorted[counter]=${string_array[index]}
		unset counter
	}
	{ $reverse; } && { mod="-"; start=1; end=${#sorted[@]}+1; }
	for (( index=${start:-0}; index < ${end:-${#sorted[@]}}; index++ )); {
		index_modified=$mod$index
		printf "${sorted[$mod$index]} "
	}
	echo
}

for _ in $@; {
	case $1 in
		-h|--help) help; exit;;
		-r|--reverse) reverse=true;;
		-t|--text) shift; sort_string "$@"; exit;;
		*)
			sort_number "$@";;
	esac
	shift
}

[[ -z $1 ]] && help
