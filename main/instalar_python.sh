#!/bin/bash

# Función para imprimir mensajes en color
print_message() {
    local COLOR=$1
    shift
    echo -e "\e[${COLOR}m$@\e[0m"
}

# Verificar si Python 3 está instalado
print_message "34" "Verificando si Python 3 está instalado..."
if command -v python3 &>/dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_message "32" "Python 3 ya está instalado: $PYTHON_VERSION"
else
    print_message "33" "Python 3 no está instalado. Procediendo con la instalación..."
    # Actualizar el índice de paquetes
    sudo apt update
    
    # Instalar Python 3
    sudo apt install -y python3
    
    # Verificar la instalación
    if command -v python3 &>/dev/null; then
        PYTHON_VERSION=$(python3 --version)
        print_message "32" "Python 3 ha sido instalado correctamente: $PYTHON_VERSION"
    else
        print_message "31" "Error: Python 3 no se pudo instalar."
        exit 1
    fi
fi

# Verificar si pip3 está instalado
print_message "34" "Verificando si pip3 está instalado..."
if command -v pip3 &>/dev/null; then
    PIP_VERSION=$(pip3 --version)
    print_message "32" "pip3 ya está instalado: $PIP_VERSION"
else
    print_message "33" "pip3 no está instalado. Procediendo con la instalación..."
    # Instalar pip3
    sudo apt install -y python3-pip
    
    # Verificar la instalación
    if command -v pip3 &>/dev/null; then
        PIP_VERSION=$(pip3 --version)
        print_message "32" "pip3 ha sido instalado correctamente: $PIP_VERSION"
    else
        print_message "31" "Error: pip3 no se pudo instalar."
        exit 1
    fi
fi

# Verificar si venv está instalado
print_message "34" "Verificando si venv está instalado..."
if python3 -m venv --help &>/dev/null; then
    print_message "32" "venv ya está instalado."
else
    print_message "33" "venv no está instalado. Procediendo con la instalación..."
    # Instalar venv
    sudo apt install -y python3-venv
    
    # Verificar la instalación
    if python3 -m venv --help &>/dev/null; then
        print_message "32" "venv ha sido instalado correctamente."
    else
        print_message "31" "Error: venv no se pudo instalar."
        exit 1
    fi
fi

print_message "32" "¡Instalación y verificación de Python completadas exitosamente!"
