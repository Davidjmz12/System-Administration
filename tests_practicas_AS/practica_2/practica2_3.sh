#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

#se comprueba el número de parámetros y se mustra, si es necesario, el correspondiente mensaje
[ $# -ne 1 ] && echo "Sintaxis: practica2_3.sh <nombre_archivo>" && exit

#si se trata de un fichero regular, se dan permisos de ejecución al usuario y al grupo y se muestra
#el estado final del fichero
[ -f "$1" ] && chmod u+x,g+x "$1" && echo $(stat --format=%A "$1")
[ -f "$1" ] || echo "$1 no existe"