# Memoria Práctica 5
## David Jiménez Omeñaca y Carlos Giralt Fuixench

### Parte 1

Vamos a trabajar con las máquinas de la práctica anterior. En ellas, instalamos `lvm2` en ambas máquinas y comprobamos que el servicio está activo con `systemctl status lvm2.service`.

Para crear las particiones primero vemos el nombre de nuestro disco con `sudo fdisk -l` y luego ejecutamos:
```bash
sudo parted /dev/sdb mklabel 
```
Dentro de la interfaz, ejecutamos:
```bash
mklabel gpt
mkpart P1 ext3 0MiB 16MiB
mkpart P2 ext4 16MiB 32MiB
```
Ahora creamos los sistemas de ficheros con
```bash
sudo mkfs.ext3 /dev/sdb1
sudo mkfs.ext4 /dev/sdb2
```
Para montarlos usamos:
```bash
mount -t ext3 /dev/sdb1 /sdb1 
mount -t ext4 /dev/sdb2 /sdb2 
```
Ahora, para añadir la configuración automática, tenemos que extraer los UUIDs realizando el siguiente comando
```bash
ls -l /dev/disk/by-uuid/ | egrep 'sdb' | cut -d '' -f 9 >> /etc/fstab
```
y una vez ahí, les damos el siguiente formato

```bash
UUID=<UUID/sdb1> /sdb1 ext3 errors=remount-ro 0 2
UUID=<UUID/sdb2> /sdb2 ext4 errors=remount-ro 0 2
```
Reiniciamos la máquina y comprobamos que se han montado con `cat /etc/mtab`.

## Parte 2

Para el primer script, primero necesitamos acceso a ssh sin contraseña. Para ello creamos y copiamos claves en ambaas máquinas (como se ha visto en la práctica anterior). Luego copiamos el script `practica_4_parte2.sh` en ambas máquinas y lo ejecutamos con la ip de la otra.

## Parte 3

Añadimos el disco de forma equivalente a la parte1. En este disco, creamos una partición completa de la misma manera, exceptoañadiendo el flag `vlm` usando el comando `set 1 lvm on`.
No montamos el disco ni añadimos la configuración en `/etc/fstab`. Ahora creamos un grupo volumen que se llama `vg_p5` con el comando `vgcreate vg_p5 /dev/etc/1`. Ahora añadimos las particiones de la parte anterior con el script creado:
```bash
bash practica_5_parte3_lv.sh vg_p5 /dev/sdb1 /dev/sdb2
```
Por lo tanto, estamos añadiendo dos volúmenes físicos.


