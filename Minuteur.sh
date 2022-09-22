#! /bin/bash

HOURS="0"
MIN="0"

function montimer ()
{
    if [[ "$MIN" -ge "60"]]
    then ((HOURS++))
        MIN="0"
    fi

    if [[ "SECONDS" -ge "60"]]
    then ((MIN++))
        SECONDS="0"
    fi

clear
echo "Temps écoulé : $HOURS heure(s) : $MIN minute(s) : $SECONDES seconde(s)"
}

function starttimer()
{

    TIMER="$1"

    for i in $(seq 1 $TIMER)
    do 
        montimer
        sleep 1
    done
        montimer
}