#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

echo -n "Introduzca el nombre del fichero: "
read file_name

#comprobamos si el fichero es regular
if test -f "$file_name"
then 
    echo -n "Los permisos del archivo "$file_name" son: "
    #comprobamos si el fichero tiene permisos de lectura
    if test -r "$file_name" 
    then 
        echo -n "r"
    else 
        echo -n "-"
    fi
    #comprobamos si el fichero tiene permisos de escritura
    if test -w "$file_name"
    then 
        echo -n "w"
    else 
        echo -n "-"
    fi 
    #comprobamos si el fichero tiene permisos de ejecución
    if test -x "$file_name"
    then
        echo "x"
    else 
        echo "-"
    fi
else
    echo "$file_name no existe"
fi