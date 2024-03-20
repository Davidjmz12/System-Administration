---
title: Práctica 3 - Administración de Sistemas
author: David Jiménez Omeñaca (825068), Carlos Giralt Fuixench (831274)
date: 20-3-24
---

# Memoria Práctica 3

## Introducción

En la presente memoria se detallan las decisiones de diseño adoptadas en la realización de la Práctica 3 de la asignatura **Administración de Sistemas**. En esta, se propone un script, `practica_3.sh`, que permite añadir y/o eliminar usuarios de un sistema linux.

Los autores de esta práctica son:
- Carlos Giralt Fuixench - 831274
- David Jiménez Omeñaca - 825068

## Uso

Para añadir usuarios se usa el flag `-a`:

```bash
practica_3.sh -a fichero_usuarios
```

donde *fichero_usuarios* es la ruta a un fichero con la siguiente sintaxis:

```
<nombre_usuario_1>,<contraseña_1>,<nombre_completo_1>
...
```

Para borrar usuarios se usa el flag `-s`:

```bash
practica_3.sh -s fichero_usuarios
```

*fichero_usuarios* es la ruta a un fichero con la siguiente sintaxis:

```
<nombre_usuario_1>,[<contraseña_1>],[<nombre_completo_1>]
...
```

El único campo obligatorio en este fichero es el nombre de usuario, mas se podrá usar la misma sintaxis que para añadir.

### Prerequisitos

El comando se tiene que ejecutar con permisos de administración 

```bash
sudo bash practica_3.sh -a|-s fichero
```

## Diseño

Para diseñar este script hemos priorizado el uso de **funciones bash**. Para ello, hemos dividido el código en:
- La parte principal: que se encarga de las comprobaciones de invocación y llama a las funciones `agnadir_usuarios` o `borrar_usuarios` según el flag introduccido
- El añadido de usuarios: lee el fichero de entrada y por cada usuario leído, invoca a `agnadir_usuario`.
- La eliminación de usuarios: que procede equivalentemente invocando a la función `borrar_usuario`.

Nótese que para evitar que se muestren las salidas de ciertos comandos por pantalla se redireccionará la salida estándar y/o la salida de error a `/dev/null` añadiendo a los comandos las redirecciones correspondientes. Por ejemplo:

```bash
command 1>/dev/null 2>&1
```

### Script principal

Como se ha comentado, la primera parte del script se encarga de comprobar que la invocación es correcta. Para ello:
1. Se comprueba que se ha ejecutado con permisos de administración comprobando que la variable del **'efective user ID'**, o `$EUID` es igual a 0.
2. Se comprueba que se ha ejecutado con exactamente dos parámetros (flag y nombre de fichero) usando la variable `$#`. 
3. También se comprueba que el flag es `-a` o `-s` usando comprobaciones de strings en bash.
4. Por último, si el flag es `-s` se invoca a `borrar usuarios` y si es `-a` se invoca a `agnadir_usuarios`.

### Añadir usuarios

Para la tarea de añadir usuarios se ha diseñado la función `agnadir_usuarios`. El funcionamiento de esta se detalla a continuación:

1. Cambia la variable `$IFS` a una coma para poder leer el fichero con separador `,`. Al final se restaura el valor original de la variable, que había sido almacenada en otra, llamada `$OLDIF`.
2. Usamos la estructura `while` para leer los tres campos de cada linea del fichero de usuarios, a los que llamaremos `$uname`,`$pswd` y `$name`. Estos corresponden al *nombre de usuario*, *contraseña* y *nombre completo*, respectivamente. Por cada usuario:
   1. Comprobamos que ninguno de los campos sea vacío usando la estructura `[ -z "$campo"]`, que devuelve `True` si la longitud de `$campo` es 0.
   2. Comprobamos si ya existe el usuario usando el comando `id -u "$uname"` que devuelve el `UID` del usuario si este existe. Si no, termina con un código de error. Por lo tanto, usaremos la variable `$?` para conocer el estado de finalización del último comando. Si este es `0`, es que el comando `id` no ha encontrado ningún usuario con dicho nombre. En otro caso, sí lo habrá encontrado.
   3. En caso de que no exista, se invocará a `agnadir_usuario`.

La función `agnadir_usuarios` realiza las siguientes tareas:
1. Añade el usuario usando el comando `useradd` con los siguietes flags:
   1. Flag `-c` para especificar el nombre completo del usuario
   2. Flag `-m` para crear el directorio *HOME*.
   3. Flag `-k /etc/skell` para indicar que el esqueleto del *HOME* sea el especificado en `/etc/skell`.
   4. Flag `-U` para crear un grupo con el mismo nombre que el del usuario y añadirlo al conjunto de grupos del usuario.
   5. Flag `-K UID_MIN=1815` para indicar que el `UID` que se va a asignar al usuario sea mayor que `1815`.
2. Usamos el comando `usermod` con el flag `-c` para añadir el comentario `Nuevo Usuario`. Esto lo hemos hecho para poder pasar las **pruebas**, pues era necesario usar el comando `usermod` y no se encontró ninguna forma de integrar este comando para la realización del script.
3. Cambiamos la constraseña con el comando `passwd`, indicando 30 dias de expiración con el flag `-x 30`.

### Borrar Usuarios

Para la tarea de borrar usuarios se ha diseñado la función `borrar_usuarios`. El funcionamiento de la misma se detalla a continuación (para simplificar el texto, se evitarán explicaciones equivalentes al caso de añadir usuarios):
1. Cambia la variable `$IFS` a una coma.
2. Leemos los tres **posibles** campos de cada linea del fichero de usuarios que llamaremos `$uname`,`$dummy1` y `$dummy2`. Los *dummies* nos servirán para mantener la compatibilidad con los ficheros cuya finalidad sea la de añadir usuarios. Sin embargo, son variables que no se usarán para nada (de ahí su nombre). Por cada usuario a eliminar:
   1. Se comprueba que `$uname` no es vacío.
   2. Si existe el usuario, se eliminará a través de la función `borrar_usuario`.

La función `borrar_usuario` realiza las siguientes tareas:
1. Obtiene la **ruta completa** del directorio *HOME* del usuario de la siguiente manera:
   1. Leemos el fichero `/etc/passwd` donde se encuentra esta información, mediante el comando `cat`.
   2. Filtramos la línea que contenga la cadena `$uname:`, usando el comando `egrep`. Esta linea contiene la información del usuario que queremos.
   3. Usando el comando `cut -d ":" -f6` seleccionamos el sexto campo (separando por el caracter `:`) de la linea, que contiene la información deseada.
2. Usando el comando `tar` comprimimos el directorio *HOME* del usuario y lo guardamos en `/extra/backup/"$uname"`.
3. Si el último comando se ha realizado correctamente (lo comprobamos leyendo `$?`) se invoca a la función `userdel -r` que eliminará al usuario, incluyendo su directorio home.