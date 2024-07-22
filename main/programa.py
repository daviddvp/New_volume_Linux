import subprocess
import os

def run_command(command):
    """Ejecuta un comando en el sistema y muestra la salida"""
    try:
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar {command}: {e}")

def main():
    # Paso 1: Crear un punto de montaje
    mount_point = "/mnt/nvme1"
    if not os.path.exists(mount_point):
        print(f"Creando punto de montaje en {mount_point}")
        run_command(f"sudo mkdir -p {mount_point}")
    else:
        print(f"El punto de montaje {mount_point} ya existe")

    # Paso 2: Formatear el dispositivo (opcional)
    device = "/dev/nvme1n1"
    format_device = input("¿Deseas formatear el dispositivo? Esto borrará todos los datos en el dispositivo. (s/n): ").strip().lower()
    if format_device == 's':
        print(f"Formateando el dispositivo {device}")
        run_command(f"sudo mkfs.ext4 {device}")

    # Paso 3: Montar el dispositivo
    print(f"Montando el dispositivo {device} en {mount_point}")
    run_command(f"sudo mount {device} {mount_point}")

    # Paso 4: Verificar el montaje
    print("Verificando el montaje")
    run_command("df -h")
    run_command("lsblk")

    # Paso 5: Utilizar rsync para sincronizar los discos
    source = "/"
    destination = f"{mount_point}/"
    print(f"Sincronizando archivos de {source} a {destination} excluyendo /mnt")
    run_command(f"sudo rsync -aAXv --progress --exclude=/mnt {source} {destination}")

    # Paso 6: Verificar la sincronización
    print("Verificando la sincronización")
    run_command(f"ls -l {destination}")

if __name__ == "__main__":
    main()
