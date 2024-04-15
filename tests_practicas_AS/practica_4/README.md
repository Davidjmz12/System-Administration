# Practica 4

## Configuración Máquinas
Para instalar sudo, desde root ejecutamos:

```bash
apt install sudo
```

Para que se pueda ejecutar cuañlquier comando sin usar contraseña, añadir en el fichero `/etc/sudoers` la siguiente linea:

```bash
as  ALL=(ALL) NOPASSWD:ALL
```

El diagrama de red es el siguiente:


Añadimos en el fichero `/etc/network/interfaces` la siguiente interfaz:

```bash
auto enp0s8
iface enp0s8 inet static
addres 192.168.56.11
netmask 255.255.255.0
```

Reiniciamos el servicio de red:

```bash
systemctl restart networking.service
```

y comprobamos que se conecta a las dos interfaces con

```bash
ip addr | egrep 'enp0s3.*UP'
ip addr | egrep 'enp0s8.*UP'
```

Para instalar el servido ssh usamos:

```bash
apt install openssh-server
```

Para configurar que root no se pueda conectar en remoto añadimos en `/etc/ssh/sshd_config` :

```bash
PermitRootLogin no
```
y reiniciamos el servicio sshd con 
```bash
sudo systemctl restart sshd
```

## Preparación infraestructura

Primero creamos las claves en el host con el siguiente comando:

```bash
ssh-keygen -t ed25519
```
especificando como nombre `~/.ssh/id_as_ed25519`.
Finalmente, la copiamos en las máquinas virtuales:

```bash
ssh-copy-key -i ~/.ssh/id_as_ed25519 as@192.168.56.11
ssh-copy-key -i ~/.ssh/id_as_ed25519 as@192.168.56.12
```

Para comprobar que funciona ejecutamos `ssh as@192.168.56.11` y vemos si entra sin pedir contraseña. Igual para la otra máquina.

## Script principal
A fin de reutilizar el script de la práctica anterior, procedemos de la siguiente manera:
1. Creamos un script *user_management.sh* que contiene el script de la práctica anterior
2. En el script *practica_4.sh* realizamos:
  1. Por cada ip del fichero, comprobamos que es alcanzable con `ping`.
  2. Si lo es copiamos mediante `scp` el script *user_management.sh* y el fichero de usuarios.
  3. Ejecutamos remotamente dicho script usando `ssh -n` con los parámetros oportunos.
  4. Borramos los ficheros.

## Pruebas
Para comprobar las pruebas, como nuestra máquina host no es virtual con usuario **as** hay que modificar...




