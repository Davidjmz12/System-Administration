#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

echo -n "Introduzca el nombre de un directorio: "
read  dir_name

[ -d "$dir_name" ] || echo "$dir_name no es un directorio"

#si, en efecto, se trata de un directorio, se usa el comando ls -l para obtener todos los ficheros y directorios ubicados en él, y 
#a través de una tubería, usando el comando grep se seleccionan, por separado los ficheros y los directorios, y con el comando wc -l 
#se cuentan las líneas, i.e., el número de ficheros y directorios, respectivamente
[ -d "$dir_name" ] && echo "El numero de ficheros y directorios en $dir_name es de $(ls -l "$dir_name" | grep "^-" | wc -l) y $(ls -l "$dir_name" | grep "^d" | wc -l), respectivamente"
