#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

while read ip
do
    # 1 ECHO_REQUEST, 2 seconds timeout
    ping -c1 -W2 "$ip" 1> /dev/null 2>&1
    if [ $? -eq 0 ]
    then
        # copiamos el script de añadido/borrado de usuarios y el fichero que contiene los usuarios en la 
        # máquina remota
        scp "tests_practicas_AS/practica_4/user_management.sh" "$2" "as@$ip:~/" 1> /dev/null 2>&1
        new_dir_2="~/$(echo "$2" | grep -o "[^/]*$")"
        # ejecutamos el script y eliminamos los ficheros previamente copiados
        ssh -n "as@$ip"  "sudo bash ~/user_management.sh $1 $new_dir_2; rm ~/user_management.sh; rm $new_dir_2" 
    else
        echo "$ip no accesible"
    fi

done < "$3"
