#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

for file in "$@"
do
    #si se trata de un fichero regular, se usa el comando more para mostrar su contenido
    [ -f "$file" ] && echo $(more "$file")
    [ -f "$file" ] || echo "$file no es un fichero"
done