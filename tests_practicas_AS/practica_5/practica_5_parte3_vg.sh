#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

OLD_IFS="$IFS"
IFS=","

while read nGV nVL t tSF dM
do
    sudo vgdisplay "$nGV" >/dev/null 2>&1
    
    # Si existe
    if [ $? -eq 0 ]
    then

    else
        
    fi

done < &1