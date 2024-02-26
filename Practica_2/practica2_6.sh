#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

#comprobamos si en el directorio raíz del usuario hay algún directorio
#que siga el patrón "binXXX"
if find ~/ -maxdepth 1 -type d  | egrep -q "bin[[:alnum:]]{3}"
then
    #si los hay, usamos el comando stat para obtener información sobre la última modificación de los directorios
    #que se encuentran en el directorio raíz del usuario. Dicha información es enviada por una tubería al comando egrep, 
    #que selecciona únicamente los que siguen el patrón "binXXX". Ordenamos la salida del comando egrep mediante 
    #el comando sort para quedarnos, posteriormente, con la primera línea, que contiene el directorio que ha sido
    #menos recientemente modificado. Para ello, usamos el comando head -n 1 (leer solo primera línea) junto con 
    #el comando cut -d "," -f1, que selecciona la cadena que aparece antes de la primera aparición del delimitador ",".
    var=$(stat -c %n,%Y ~/* | egrep $HOME'/bin[[:alnum:]]{3},*' | sort -k2 -t$',' -n | head -n 1 | cut -d "," -f1)
else
    #si no lo hay, lo creamos
    var=$(mktemp -d ~/binXXX) && echo "Se ha creado el directorio $var"
fi

echo "Directorio destino de copia: $var"

counter=0

#Si no se requiere mostrar mensajes por pantalla se puede hacer con xargs.
#find . -maxdepth 1 -type f -executable | xargs -I file cp file ~/$var

#seleccionamos los ficheros ejecutables que se encuentran en el directorio 
#no seleccionamos ficheros en directorios dentro del directorio
for file in $(find . -maxdepth 1 -type f -executable)
do
    counter=$((++counter))
    cp "$file" "$var"
    echo "$file ha sido copiado a $var"
done

[ $counter -eq 0 ] && echo "No se ha copiado ningun archivo"
[ $counter -eq 0 ] || echo "Se han copiado $counter archivos"