#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

[ $# -ne 1 ] && echo "Invocar como: $0 <ip>" && exit 1

usr="as@$1"

echo -e "Discos Tamaño"
ssh "$usr" 'sudo sfdisk -s | head -n -1'

echo "==========================================="

echo -e "Particiones Tamaño"
ssh "$usr" 'sfdisk -l | egrep "^/" | sed -r "s/[ *]"+/ /g" | cut -d " " -f1,5"'

echo "==========================================="
echo -e "Particion Tipo Montaje Tamaño Libre"
ssh "$usr" 'df -hT | egrep -v "^tmpfs" | tail -n +2 | sed -r "s/ +/ /g" | cut -d " " -f1,2,7,3,5'

