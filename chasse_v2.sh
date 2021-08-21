#!/bin/bash
base=CarnetsDeVoyage

filtrage(){
   ls $base | grep 19[7-9][0-9][-,_][A-Z] 
}

identify_rep(){
    rep=$base/$1
    size_max=0
    for i in $*
    do
	if [ -d $base/$i ]
	then   
	    size=$(du -bs $base/$i | cut -f 1)
	    if [ $size -gt $size_max ]
	    then
		size_max=$size
		rep=$base/$i
	    fi
	fi
    done
    echo $rep
}

find_itineraries() {
    find $1 -type f -name "*Itineraire*"
}

find_signature(){
    for i in $*
    do
	if grep Bilbon $i > /dev/null
	then
	   echo $i
	fi
    done
}

check(){
  grep à $1 | sort | head -n 3 | cut -c 1 | tr "\n" " "
}

find_cle(){
    for i in $*
    do
	if grep CEL $i > /dev/null
	then
	    echo $i
	fi
    done
    
}


rep=$(identify_rep $(filtrage))
#check $(find_signature $(find_itineraries $rep))
#find_cle $(find_itineraries $rep)
echo $(find_itineraries $rep)
