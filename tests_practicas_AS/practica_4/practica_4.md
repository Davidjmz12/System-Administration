# Practica 4

## Configuración de las máquinas
Para instalar el comando `sudo`, ejecutamos el siguiente comando desde el usuario **root**:

```bash
apt-get install sudo
```

Para que el usuario **as** pueda ejecutar cualquier comando sin usar su contraseña, añadir, en el fichero `/etc/sudoers`, la siguiente línea:

```bash
as  ALL=(ALL) NOPASSWD:ALL
```

Configuramos una nueva interfaz de red añadiendo, en el fichero, `/etc/network/interfaces` las siguientes líneas:

```bash
auto enp0s8
iface enp0s8 inet static
addres 192.168.56.11
netmask 255.255.255.0
```

Reiniciamos el servicio de red para que hagan efecto los cambios, mediante:

```bash
systemctl restart networking.service
```

Y comprobamos que, en efecto, las máquinas se conectan a las dos interfaces, mediante:

```bash
ip addr | egrep 'enp0s3.*UP'
ip addr | egrep 'enp0s8.*UP'
```

Para instalar el servidor *ssh* en las máquinas, usamos:

```bash
apt-get install openssh-server
```

Configuraos el servidor *ssh* de modo que root no se pueda conectar en remoto añadiendo, en el fichero `/etc/ssh/sshd_config`, la siguiente línea:

```bash
PermitRootLogin no
```
y reiniciamos el servicio *sshd*, mediante 

```bash
sudo systemctl restart sshd
```

## Preparación de la infraestructura

En primer lugar, generamos las claves pública-privada en el host mediante el siguiente comando:

```bash
ssh-keygen -t ed25519
```
especificando `~/.ssh/id_as_ed25519` como nombre del fichero en el que almacenar la clave privada.

Finalmente, la copiamos en las máquinas virtuales, mediante el comando:

```bash
ssh-copy-key -i ~/.ssh/id_as_ed25519 as@192.168.56.11
ssh-copy-key -i ~/.ssh/id_as_ed25519 as@192.168.56.12
```

Para comprobar que la configuración ha sido un éxito, ejecutamos `ssh as@192.168.56.11` y verificamos que se accede sin pedir contraseña. Ídem para la otra máquina.

## Script principal
A fin de reutilizar el script de la práctica anterior, procedemos de la siguiente manera:
1. Creamos un script, *user_management.sh*, que contiene el script de la práctica anterior
2. En el script *practica_4.sh* se llevan a cabo las siguientes tareas:
  1. Por cada ip del fichero, comprobamos que la máquina es alcanzable con el comando `ping`, indicando un único `ECHO_REQUEST` y un timeout de 1 segundo.
  2. Si lo es, copiamos, mediante `scp`, el script *user_management.sh* y el fichero que contiene la lista de usuarios en la máquina remota.
  3. Ejecutamos remotamente dicho script usando `ssh -n` con los parámetros oportunos.
  4. Borramos los ficheros.

## Pruebas
Con tal de poder usar las pruebas facilitadas por el equipo docente de la asignatura, al estar ejecutándolas en nuestra máquina y no en una máquina virtual, debemos modficar la ruta en la que el test busca el fichero que contiene la clave privada que hemos generado. 




