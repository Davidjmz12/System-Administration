#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

# Ejecutar como root

OLD_IFS="$IFS"
IFS=","

if [ $# -lt 1 ]
then
    echo "Invocar como: $0 <file.txt>"
fi

while read nGV nVL t tSF dM
do

    device="/dev/${nGV}/${nVL}"
    # Mirar si existe el volumen lógico
    # lvdisplay "/dev/${nGV}/${nVL}" ??
    # lvscan | egrep '$nVL' ??
    
    # Si existe
    if [ $? -eq 0 ]
    then

        echo "Extendemos a tamaño: $t"
        # Extender el volumen lógico
        lvextend -L $t $device >/dev/null 2>&1
    else # SI no existe
        
        echo "Creamos el volumen logico"
        # Creamos el volúmen lógico
        lvcreate -L "$t" --name "$nVL" "$nGV" >/dev/null 2>&1

        echo "Formateamos"
        # Le damos formato
        mkfs -t "$tSF" "$device" >/dev/null 2>&1


        echo "Montamos"
        # Montamos
        mount -t "$tSF" "$device" >/dev/null 2>&1

        # Buscamos para añadirlo en montado automático
        UUID_device=$(lsblk -o NAME,UUID | egrep '$nVL' | awk '{print $2}')

        echo "Escribimos en fstab para montaje automático..."
        echo "UUID=$UUID_device $dM $tSF errors=remount-ro 0 2" | tee /etc/fstab 

    fi

done < $1