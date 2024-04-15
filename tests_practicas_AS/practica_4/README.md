# Practica 4

## Configuración Máquinas
Para instalar sudo, desde root ejecutamos:

apt install sudo

Para que se pueda ejecutar cuañlquier comando sin usar contraseña, añadir en el fichero `/etc/sudoers` la siguiente linea:

```bash
as  ALL=(ALL) NOPASSWD:ALL
```

El diagrama de red es el siguiente:


Añadimos en el fichero `/etc/network/interfaces`

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




