#!/usr/bin/env bash

base="CarnetsDeVoyage"

filtrage() {
	echo $base/19[7-9][0-9][-_][A-Z]*
}

identify_rep() {
	rep=$1
	shift
	for var in $@; do
		if [[ $(du $rep | tail -1 | cut -f1) -lt $(du $var | tail -1 | cut -f1) ]]; then
			rep=$var
		fi
	done
	echo $rep
}

find_itineraries() {
	find $1 -type f | grep "Itineraire"
}

find_signature() {
	for var in $@; do
		if grep "Bilbon" $var > /dev/null; then
			echo $var
		fi
	done
}

rep=$(identify_rep $(filtrage))

cle=$(find_signature $( find_itineraries $rep))

#cat $cle | grep "à" | sort | head -3 | cut -c-1 | tr -d '\n'; echo

tmp=$(cat $cle | sort -k 3 -f | grep . | awk '{print $3}')
mots=$(printf "$(echo $tmp| tr " " "\n" | head -2)\n$(echo $tmp| tr " " "\n" | tail -2)")

cat "$base/$(echo $mots | tr " " "/")"
