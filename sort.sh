#!/bin/env bash

reverse=false

help(){
	while read; do
		printf "%s\n" "$REPLY"
	done << EOF
Usage: sort { options } { sort type } { data to be sorted }

 -r, --reverse Reverses the order of sort process

 -c, --char    Compares every single character
               in a given string and sorts accordingly

 -w, --word    Takes in each word and sorts
               that word's letters amongst each other

 -n, --number  Number sorting, both positive and
               negative numbers

 -t, --text    Compares words amongst each other
               and sorts accordingly

Arguments are expected after data type specifiers such as char, \
word, number etc.. Options such as reverse must come before the \
data specifiers.
EOF
}

sort_number(){
	num_array=($@)
	len=${#num_array[@]}
	for (( iter=0; iter < len-1; iter++ )); {
		for (( index=0; index < len-1-iter; index++ )); {
			if { $reverse; }; then
				(( ${num_array[index]} < ${num_array[index+1]} )) && {
					temp=${num_array[index]}
					num_array[index]=${num_array[index+1]}
					num_array[index+1]=$temp
				}
			else
				(( ${num_array[index]} > ${num_array[index+1]} )) && {
					temp=${num_array[index]}
					num_array[index]=${num_array[index+1]}
					num_array[index+1]=$temp
					}
			fi
		}
	}
	printf "%s " "${num_array[@]}"
	echo
}

sort_string(){
	string_array=($@)
	len=${#string_array[@]}
	for (( iter=0; iter < len-1; iter++ )); {
		for (( index=0; index < len-1-iter; index++ )); {
			if { $reverse; }; then
				[[ ${string_array[index]} < ${string_array[index+1]} ]] && {
					temp=${string_array[index]}
					string_array[index]=${string_array[index+1]}
					string_array[index+1]=$temp
				}
			else
				[[ ${string_array[index]} > ${string_array[index+1]} ]] && {
					temp=${string_array[index]}
					string_array[index]=${string_array[index+1]}
					string_array[index+1]=$temp
					}
			fi
		}
	}
	printf "%s " "${string_array[@]}"
	echo
}

sort_char(){
	char_array=$@
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
	word_array=($@)
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
		-f|--file)
			shift
			[[ -f $1 ]] && args=$(<$1) || \
				{ printf "%s\n" "No file found"; exit 1; };;
		-t|--text) 
			shift
			[[ -z $args ]] &&  args=$@
			[[ -z $args ]] && readarray args
			sort_string "${args[@]}"
			exit;;
		-w|--word)
			shift
			[[ -z $args ]] &&  args=$@
			[[ -z $args ]] && readarray args
			sort_word "${args[@]}"
			exit;;
		-c|--char)
			shift
			[[ -z $args ]] &&  args=$@
			[[ -z $args ]] && readarray args
			sort_char "${args[@]}"
			exit;;
		-n|--number)
			shift
			[[ -z $args ]] &&  args=$@
			[[ -z $args ]] && readarray args
			sort_number "${args[@]}"
			exit;;
		-*) printf "%s\n" "$1 parameter does not exist"; exit 1;;
		*) printf "%s\n" "Data type needs to be specified"; exit 1;;
	esac
	shift
}

