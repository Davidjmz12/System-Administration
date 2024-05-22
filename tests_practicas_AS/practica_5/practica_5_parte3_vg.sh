#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

# Ejecutar como root

OLD_IFS="$IFS"
IFS=","

while read nGV nVL t tSF dM
do

    device="/dev/${nGV}/${nVL}"
    # Mirar si existe el volumen lógico
    # lvdisplay "/dev/${nGV}/${nVL}" ??
    # lvscan | egrep '$nVL' ??
    
    # Si existe
    if [ $? -eq 0 ]
    then
        # Extender el volumen lógico
        lvextend -L $t $device
    else # SI no existe
        
        # Creamos el volúmen lógico
        lvcreate -L "$t" --name "$nVL" "$nGV" 

        # Le damos formato
        mkfs -t "$tSF" "$device"

        # Montamos
        mount -t "$tSF" "$device"

        # Buscamos para añadirlo en montado automático
        UUID_device=$(lsblg -o NAME,UUID | egrep '$nVL' | awk '{print $2}')

        echo "UUID=$UUID_device $dM $tSF errors=remount-ro 0 2" > /etc/fstab 


    fi

done < &1