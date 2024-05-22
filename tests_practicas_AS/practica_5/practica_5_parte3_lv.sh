#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

# Ejecutar como root

[ $# -le 1 ] && echo "Invocar como: $0 <grupo_volumen> <particion1> <particion2> ..." && exit 1

volume_group="$1"

shift 1 # Quitamos el argumento $1 (gropo volumen)

for par in "$@"
do
    echo "Desmontando $par"
    umount "$par" #> /dev/null 2>&1
    
    echo "Creando volumen físico"
    pvcreate "$par" #> /dev/null 2>&1

    echo "Agnadir partición al grupo"
    vgextend -f "$volume_group" "$par"  #> /dev/null 2>&1
done
