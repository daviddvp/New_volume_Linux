#!/bin/bash

# Directorio donde se encuentran los scripts
SCRIPT_DIR="main"

# Ejecutar paso_1.sh
echo "Verificando si python esta instalado en el sistema..."
bash "$SCRIPT_DIR/instalar_python.sh"

# Verificar si paso_1.sh se ejecutó correctamente
if [ $? -ne 0 ]; then
    echo "Error: El script paso_1.sh falló. Abortando..."
    exit 1
fi

# Ejecutar python.py
echo "Ejecutando el programa..."
python3 "$SCRIPT_DIR/prog_interactivo.py"

# Verificar si python.py se ejecutó correctamente
if [ $? -ne 0 ]; then
    echo "Error: El script python.py falló."
    exit 1
fi

echo "Scripts ejecutados exitosamente."
