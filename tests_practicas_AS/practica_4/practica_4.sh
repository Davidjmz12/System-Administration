#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A


# FICHERO PARA CONEXIÓN A MÁQUINAS Y CREACIÓN/ELIMINACIÓN DE USUARIOS

[ $UID -ne 0 ] && echo "Este script necesita privilegios de administracion" && exit 1

#D
[ $# -ne 3 ] && echo "Numero incorrecto de parametros" && exit

#C
[ "$1" != "-a" ] && [ "$1" != "-s" ] && >&2 echo "Opcion invalida" && exit

while read ip
do
    # Quiet, 1 ping, 2 seconds timeout
    ping -c1 -W2 -q "$ip"
    if [ $? -eq 0 ]
    then
        scp "test_practicas_AS/practica_4/user_management.sh" "$2" "as@$ip:~/"
        new_dir_2="~/$(echo "$2" | grep -o "[^/]*$")"
        ssh -n "as@$ip"  "~/user_management.sh $1 $new_dir_2; rm ~/user_management.sh; rm $new_dir_2" 
    else
        echo "$ip no accesible"
    fi

done < "$3"
