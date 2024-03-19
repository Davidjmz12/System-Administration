# Decisiones de diseño tomadas en la práctica 3 de Administración de Sistemas
- Carlos Giralt Fuixench - 831274
- David Jiménez Omeñaca - 825068

## Main
En primer lugar, para determinar si el usuario que ejecuta el script tiene privilegios de administración, decidimos consultar el valor de la variable ***EUID***. En caso de que su valor sea distinto de **cero**, muestra el mensaje pertinente por pantalla y termina la ejecución. Por último, se comprueba que el número de parámetros sea el adecuado, así como que el primero tome el valor "-a" o "-s". En caso contrario, se muestra el mensjae apropiado por pantalla.

## Añadido de usuarios 
Como los campos de los usuarios están separados por el caracter ",", lo primero que hacemos es modificar el valor de la variable ***IFS*** apropiadamente para que, al leer cada línea del fichero en el que se encuentran los usuarios a añadir, podamos leer y almacenar cada campo en una variable diferente. Además, guardamos el valor antiguo de ***IFS*** en otra variable para restaurarla al acabar. Para cada línea del fichero, se comprueba si alguno de los campos es vacío, en cuyo caso se muestra el mensaje adecuado por pantalla y se termina la ejecución del script. En caso contrario, se comprueba si ya existe algún usuario con el mismo nombre de usuario que el dado. Si no existe, se usa el comando `useradd` para añadir el nuevo usuario, junto con las opciones -k, 