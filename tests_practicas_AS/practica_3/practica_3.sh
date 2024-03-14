#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A


agnadir_usuarios () {
    echo $1

}

borrar_usuarios () {
    echo $1
}


echo "Este script necesita privilegios de administracion"

[ $# -ne 2 ] && echo "Numero incorrecto de parametros" && exit
[ "$1" != "-a" ] && [ "$1" != "-s" ] && >&2 echo "Opcion invalida" && exit


if [ $1 = "-a" ]
then
    agnadir_usuarios $2
else
    borrar_usuarios $2
fi