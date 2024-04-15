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


