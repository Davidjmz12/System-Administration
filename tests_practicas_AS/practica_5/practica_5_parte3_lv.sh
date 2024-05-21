#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

add_partition() {
    par="$1"

    echo "Desmontando $par"
    sudo umount "$par" > /dev/null 2>&1


    echo "Agnadir partición al grupo"
    sudo vgextend -f "$volume_group" "$par"  > /dev/null 2>&1
}

[ $# -le 1 ] && echo "Invocar como: $0 <grupo_volumen> <particion1> <particion2> ..." && exit 1

volume_group="$1"

shift 1 # Quitamos el argumento $1 (gropo volumen)

echo "$@" | xargs -d" " -I partition add_partition "partition"
