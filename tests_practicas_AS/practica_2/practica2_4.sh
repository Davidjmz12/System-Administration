#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

echo -n "Introduzca una tecla: "
read teclas

# tecla=$(echo "$teclas" | head -c 1)
tecla=${teclas:0:1}

case $tecla in
    #se comprueba si la tecla pulsada es un número
    [0-9] ) 
        echo "$tecla es un numero" ;;
    #se comprueba si la tecla pulsada es una letra
    [a-zA-Z] ) 
        echo "$tecla es una letra" ;;
    #si no, es un caracter especial
    *) 
        echo "$tecla es un caracter especial" ;;
esac