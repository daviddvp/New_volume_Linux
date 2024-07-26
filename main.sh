#!/bin/bash

run_command() {
    "$@"
    if [ $? -ne 0 ]; then
        echo "Error al ejecutar $@"
        exit 1
    fi
}

# Paso 1: Crear un punto de montaje
read -p "Ingresa el punto de montaje (por ejemplo, /mnt/nvme1): " mount_point
if [ ! -d "$mount_point" ]; then
    echo "Creando punto de montaje en $mount_point"
    run_command sudo mkdir -p "$mount_point"
else
    echo "El punto de montaje $mount_point ya existe"
fi

# Paso 2: Formatear el dispositivo (opcional)
read -p "Ingresa el nombre del dispositivo (por ejemplo, /dev/nvme1n1): " device
read -p "¿Deseas formatear el dispositivo? Esto borrará todos los datos en el dispositivo. (s/n): " format_device
format_device=${format_device,,} # Convertir a minúsculas
if [ "$format_device" == "s" ]; then
    read -p "Ingresa el tipo de sistema de archivos (por ejemplo, ext4): " fs_type
    echo "Formateando el dispositivo $device con el sistema de archivos $fs_type"
    run_command sudo mkfs."$fs_type" "$device"
fi

# Paso 3: Montar el dispositivo
echo "Montando el dispositivo $device en $mount_point"
run_command sudo mount "$device" "$mount_point"

# Paso 4: Verificar el montaje
echo "Verificando el montaje"
run_command df -h
run_command lsblk

# Paso 5: Utilizar rsync para sincronizar los discos 
# Verificar origen de los datos
source="/" # Cambiar este valor para copiar un segundo disco
destination="${mount_point}/"
echo "Sincronizando archivos de $source a $destination excluyendo /mnt"
run_command sudo rsync -aAXv --progress --exclude=/mnt "$source" "$destination"

# Paso 6: Verificar la sincronización
echo "Verificando la sincronización"
run_command ls -l "$destination"
