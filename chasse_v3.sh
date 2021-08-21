#!/bin/bash
base=CarnetsDeVoyage
filtrage() {
    for x in $(ls $base | grep ^19[7-9][0-9][-,_][A-Z])
    do
    echo $x
    done

}

identify_rep() {
    local max taille rep
    max=$((0))
    for x in $@
    do
    if [ -d $base/$x ]
    then 
        taille=$(echo $(du -bs $base/$x) | awk '{print $1}')
        if [ $max -lt $taille ]
        then 
            max=$taille
            rep=$base/$x
        fi
    fi 
    done
    echo $rep
}


find_itineraries() {
    find $* -type f -name "*Itineraire*" 
}


find_signature() {
    for x in $@ 
    do
    cat $x | grep -E [b,B]ilbon > /dev/null 
    if [ $? -eq 0 ]
    then 
        echo $x
    fi
    done

}

check() {
echo $(cat $1 | grep -E 'à' | sort | head -n 3 | cut -c 1 )
}

tresor() {
    local mots tresor
    cat $* | sort -k 3 | grep -vE "^$" > Itineraire_trie.txt
    cat Itineraire_trie.txt | head -n 2 > Itineraire_trie_compact.txt
    cat Itineraire_trie.txt | tail -n 2 >> Itineraire_trie_compact.txt
    mots=$(cut -f 3 -d ' ' Itineraire_trie_compact.txt )
    tresor=$(echo $mots | tr ' ' '/')
    less $base/$tresor
}

rep=$( identify_rep $( filtrage ) )
tresor $(find_signature $( find_itineraries $rep ))
