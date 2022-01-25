#!/bin/env bash

reverse=false

help(){
    printf "\n\033[1;31m%s \033[1;33m%s \033[0m%s\n\n" \
			"Usage:" "sort" "{ options } { sort type } { data to be sorted }"
	printf "\033[1;33m%s\033[1;0m%s\n:\n\033[1;33m%s\033[1;0m%s\n%s\n:\n\033[1;33m%s\033[1;0m%s\n%s\n:\n\033[1;33m%s\033[1;0m%s\n%s:\n" \
							"-r, --reverse:" "Reverses the order of sort process" \
							"-c, --char:"	 "This flag compares every single character" \
										  	 ":in a given string and sorts accordingly" \
							"-w, --word:" 	 "This flag takes in each word and sorts" \
											 ":that word's letters amongst each other" \
							"-t, --text:"    "This flag compares words amongst each other" \
											 ":and sorts accordingly"  | column -t -s ":"
	printf "\n\n\033[1;31m%s%s%s\033[0m\n\n" "Arguments are expected as the last parameter. If flags " \
											 "such as char, word etc is specified then arguments must come " \
											 "after the flag. Default sorting type is numeric. Flag isn't needed."
}
 
sort_number(){
	num_array=("$@")
	for (( index=0; index < ${#num_array[@]}; index++ )); {
		for (( iter=0; iter < ${#num_array[@]}; iter++ )); {
			(( ${num_array[index]} > ${num_array[iter]} )) && (( counter++ ))
		}
		sorted[counter]=${num_array[index]}
		unset counter
	}
	{ $reverse; } && { mod="-"; start=1; end=${#sorted[@]}+1; }
	for (( index=${start:-0}; index < ${end:-${#sorted[@]}}; index++ )); {
		index_modified=${mod}${index}
		printf "%b" "${sorted[${mod}${index}]} "
	}
	echo
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
		index_modified=${mod}${index}
		printf "${sorted[${mod}${index}]} "
	}
	echo
}

sort_char(){
	char_array="$@"
	for char in {a..z}; {
		while read -n1 letter; do
			[[ ${letter,,} == $char ]] && {
				{ $reverse; } && sorted=${letter}${sorted} \
							  || sorted+=$letter
			}
		done <<< "$char_array"
	}
	printf "%s\n" "$sorted"
}

sort_word(){
	word_array=("$@")
	for word in ${word_array[@]}; {
		for char in {a..z}; {
			while read -n1 letter; do
				[[ ${letter,,} == $char ]] && {
					{ $reverse; } && new_word=${letter}${new_word} \
								  || new_word+=$letter
				}
			done <<< $word
		}
		sorted+="$new_word "
		unset new_word
	}
	printf "%s\n" "$sorted"
}

for _ in $@; {
	case $1 in
		-h|--help) help; exit;;
		-r|--reverse) reverse=true;;
		-t|--text) shift; sort_string "$@"; exit;;
		-w|--word) shift; sort_word "$@"; exit;;
		-c|--char) shift; sort_char "$@"; exit;;
		*) sort_number "$@"; exit;;
	esac
	shift
}

[[ -z $1 ]] && help
