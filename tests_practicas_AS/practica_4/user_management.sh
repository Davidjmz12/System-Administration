#!/bin/bash
#825068, Jimenez, David, T, 1, A
#831274, Giralt, Carlos, T, 1, A

agnadir_usuario () {
    
    uname="$1"
    pswd="$2"
    name="$3"

    # Si puede existir ya un grupo con el mismo nombre...
    # if  [ $(getent group "$uname") ] 
    # then
    #     useradd -c "$name" "$uname" -m -k /etc/skel -g "$uname" -K UID_MIN=1815 > /dev/null 
    # else
    #     useradd -c "$name" "$uname" -m -k /etc/skel -U -K UID_MIN=1815 > /dev/null
    # fi
    useradd -c "$name" "$uname" -m -k /etc/skel -U -K UID_MIN=1815 > /dev/null
    usermod -c "$name" "$uname" 1> /dev/null 2>&1

    echo -e "$uname:$pswd" | chpasswd -c SHA256  > /dev/null 

    #F
    passwd -x 30 "$uname" > /dev/null 
    echo "$name ha sido creado"
}

agnadir_usuarios () {
    OLDIF="$IFS"
    IFS=","

    while read uname pswd name
    do
        #H
        ( [ -z "$uname" ]  || [ -z "$pswd" ] || [ -z "$name" ] ) && echo "Campo invalido" && exit

        #L,M,K
        id -u "$uname" 1> /dev/null 2>&1
        #G
        if [ $? -eq 0 ]
        then
            echo "El usuario $uname ya existe"
        else
            #Crear usuaro
            agnadir_usuario "$uname" "$pswd" "$name"

        fi

    done < "$1"


    IFS="$OLDIF"
}

borrar_usuario () {
    uname="$1"
    
    home_us=$(cat /etc/passwd | egrep "$uname:" | cut -d ":" -f6)
    
    #P
    tar -cpf /extra/backup/"$uname".tar "$home_us" 1> /dev/null 2>&1 
    
    #R
    if [ $? -eq 0 ]
    then
        userdel -r "$uname" 1> /dev/null 2>&1
    fi
}

borrar_usuarios () {
    OLDIF="$IFS"
    IFS=","

    #Q
    mkdir -p /extra/backup

    #E
    while read uname dummy1 dummy2  #leemos cada línea del fichero
	do
		if [ -n "$uname" ] #Comprobamos que no es vacío
		then
            id -u "$uname" 1> /dev/null 2>&1
            #I
            if [ $? -eq 0 ]
            then
                #Borrar usuario
                borrar_usuario "$uname"
            fi
        fi
    done < "$1"


    IFS="$OLDIF"
}

[ $UID -ne 0 ] && echo "Este script necesita privilegios de administracion" && exit 1

#D
[ $# -ne 2 ] && echo "Numero incorrecto de parametros" && exit

#C
[ "$1" != "-a" ] && [ "$1" != "-s" ] && >&2 echo "Opcion invalida" && exit

if [ $1 = "-a" ]
then
    agnadir_usuarios "$2"
else
    borrar_usuarios "$2"
fi