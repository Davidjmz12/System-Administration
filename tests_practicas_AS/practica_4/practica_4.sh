#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A


# FICHERO PARA CONEXIÓN A MÁQUINAS Y CREACIÓN/ELIMINACIÓN DE USUARIOS



while read ip
do
    # Quiet, 1 ping, 2 seconds timeout
    ping -c1 -W2 "$ip" 1> /dev/null 2>&1
    if [ $? -eq 0 ]
    then
        scp "tests_practicas_AS/practica_4/user_management.sh" "$2" "as@$ip:~/" 1> /dev/null 2>&1
        new_dir_2="~/$(echo "$2" | grep -o "[^/]*$")"
        ssh -n "as@$ip"  "sudo bash ~/user_management.sh $1 $new_dir_2; rm ~/user_management.sh; rm $new_dir_2" 
    else
        echo "$ip no accesible"
    fi

done < "$3"
