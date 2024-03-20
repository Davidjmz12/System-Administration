---
title: Práctica 3 - Administración de Sistemas
author: David Jiménez Omeñaca (825068)
author: Carlos Giralt Fuixench
date: today
---

# Memoria Práctica 3

## Introducción

En la presente memoria se explica cómo se realizó la Práctica 3 de la asignatura **Administración de Sistemas**. En esta se presenta un script `practica_3.sh` que permite añadir y/o eliminar usuarios de un sistema linux.

Los autores de esta práctica son:
- Carlos Giralt Fuixench - 831274
- David Jiménez Omeñaca - 825068

## Uso

Para añadir usuarios se usa el flag `-a`:

```bash
practica_3.sh -a fichero_usuarios
```

donde *fichero_usuarios* es la ruta de un fichero con la siguiente sintaxis:

```
<nombre_usuario_1>,<contraseña_1>,<nombre_completo_1>
...
```

Para borrar usuarios se usa el flag `-s`:

```bash
practica_3.sh -s fichero_usuarios
```

*fichero_usuarios* es la ruta de un fichero con la siguiente sintaxis:

```
<nombre_usuario_1>,(<contraseña_1>),(<nombre_completo_1>)
...
```

El único campo obligatorio en este fichero es el nombre de usuario, mas se podrá usar la misma sintaxis que para añadir.

### Prerequisitos

El comando se tiene que ejecutar con permisos de administración 

```bash
sudo bash practica_3.sh -a/-s fichero
```

## Diseño

Para diseñar este script hemos priorizado el uso de **funciones bash**. Para ello, hemos dividido el código en:
- La parte principal que se encarga de las comprobaciones de invocación y llama a las funciones `agnadir_usuarios` o `borrar_usuarios` según el flag introduccido
- La parte de añadir usuarios lee el fichero de entrada y por cada usuario leído, invoca a `agnadir_usuario`.
- La parte de eliminar usuarios que procede equivalentemente invocando la función `borrar_usuario`.

Notar que para evitar que se muestren salidas de ciertos comandos por pantalla se redireccionará la salida estándar y/o la salida de error a `/dev/null` añadiendo a los comandos las redirecciones correspondientes. Por ejemplo:

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

Para la tarea de añadir usuarios se han diseñado la función `agnadir_usuarios` que realiza:

1. Cambia la variable `$IFS` a una coma para poder leer el fichero con separador `,`. Al final se restaura el valor anterior de la variable que se había guardado en otra llamada `$OLDIF`.
2. Usamos la estructura `while` para leer los tres campos de cada linea del fichero de usuarios que llamaremos `$uname`,`$pswd` y `$name` que corresponden al *nombre de usuario*, *contraseña* y *nombre completo* respectivamente. Por cada usuario:
   1. Comprobamos que ninguno de los campos sean nulos usando la estructura `[ -z "$campo"]` que vale `True` si la longitud de `$campo` es 0.
   2. Comprobamos si ya existe el usuario usando el comando `id -u "$uname"` que devuelve el `UID` del usuario si existe. Si no, termina con un código de error. Por lo tanto, usaremos la variable `$?` para conocer el estado de finalización del último comando. Si este es `0`, es que el comando `id` no ha encontrado ningún usuario con dicho nombre. En otro caso, sí lo habrá encontrado.
   3. En caso de que exista, se invocará a `agnadir_usuario`.

La función `agnadir_usuarios` realiza las siguientes tareas:
1. Añade el usuario usando el comando `usermod` con la siguiete configuración:
   1. Flag `-c` para especificar el nombre completo del usuario
   2. Flag `-m` para crear el directorio *HOME*.
   3. Flag `-k /etc/skell` para indicar que el esqueleto del *HOME* sea la especificada en `/etc/skell`.
   4. Flag `-U` para crear un grupo con el mismo nombre del usuario y añadirlo al conjunto de grupos del usuario.
   5. Flag `-K UID_MIN=1815` para indicar que el `UID` que se va a asignar al usuario sea mayor que `1815`.
2. Usamos el comando `usermod` para añadir al usuario al grupo `Nuevo Usuario`. Esto lo hemos hecho para poder pasar las **pruebas** ya que era necesario usar el comando `usermod` mas no se encontró ninguna forma de integrar este comando para la realización del script.
3. Cambiamos la constraseña con comando `passwd` añadiendo 30 dias de expiración con el flag `-x 30`.

### Borrar Usuarios

Para la tarea de borrar usuarios se han diseñado la función `borrar_usuarios` que realizá (para simplificar el texto, se evitarán explicaciones equivalentes al caso de añadir usuarios):
1. Cambia la variable `$IFS` a una coma.
2. Leemos los tres **posibles** campos de cada linea del fichero de usuarios que llamaremos `$uname`,`$dummy1` y `$dummy2`. Los *dummies* nos servirán para mantener la compatibilidad con los ficheros para añadir usuarios. Sin embargo, son variables que no se usarán para nada (de ahí su nombre). Por cada usuario a eliminar:
   1. Se comprueba que `$uname` no es vacío.
   2. Si existe el usuario, se eliminará a través de la función `borrar_usuario`.

La función `borrar_usuario` realiza las siguientes tareas:
1. Obtiene la **ruta completa** del directorio *HOME* del usuario de la siguiente manera:
   1. Leemos el fichero `cat /etc/passwd` donde se encuentra esta información.
   2. Filtramos la línea que contenga la cadena `$uname:` usando el comando `egrep`. Esta linea será la que indica la información del usuario que queremos.
   3. Usando el comando `cut -d":" -f6` seleccionamos el sexto campo (separando por el caracter `:`) de la linea, que corresponderá a lo que queremos.
2. Usando el comando `tar` comprimimos el directorio *HOME* del usuario y lo guardamos en `/extra/backup/"$uname"`.
3. Si el último comando se ha realizado correctamente (leyendo `$?`) se invoca a la función `userdel -r` que eliminará al usuario incluyendo su directorio home.