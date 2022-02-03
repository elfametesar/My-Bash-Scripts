#!/usr/bin/env bash

# Quick sort in Bash

# function to find the partition position
partition() {
  array=(${@:3:${#@}})
  # choose the rightmost element as pivot
  pivot=${array[$2]}

  # pointer for greater element
  i=$(( $1 - 1 ))

  # traverse through all elements
  # compare each element with pivot
  for((j=$1; j < $2; j++)) {
	  if (( ${array[j]} <= pivot )); then
		  # if element smaller than pivot is found
		  # swap it with the greater element pointed by i
		  (( i++ ))

		  # swapping element at i with element at j
		  IFS=" " read array[i] array[j] <<< \
			  "${array[j]} ${array[i]}"
	  fi
  }
  # swap the pivot element with the greater element 
  IFS=" " read array[i+1] array[$2] \
	  <<< "${array[$2]} ${array[i+1]}"
  # return the position from where partition is done
  pi=$(( i + 1 ))
}

# function to perform quicksort
quickSort() {
	array=(${@:3:${#@}})
	if (( $1 < $2 )); then

		# find pivot element such that
		# element smaller than pivot are on the left
		# element greater than pivot are on the right
		partition $1 $2 ${array[@]}

		# recursive call on the left of pivot
		quickSort $1 $(( pi - 1 )) ${array[@]}

		# recursive call on the right of pivot
		quickSort $(( pi + 1 )) $2 ${array[@]}
	fi
}

for _ in {0..99}; {
	array+=($RANDOM)
}

echo "Unsorted Array:"
echo ${array[@]}
echo 

size=${#array[@]}
quickSort 0 $(( size - 1)) ${array[@]}

echo "Sorted Array in Ascending Order:"
echo ${array[@]}
