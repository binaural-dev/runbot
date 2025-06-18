#!/bin/bash

# Actualizar paquetes y dependencias
echo "Actualizando paquetes..."
sudo apt update && sudo apt upgrade -y

# Instalar Python y dependencias
echo "Instalando Python..."
sudo apt install -y python3 python3-pip python3-venv

# Instalar Docker
echo "Instalando Docker..."
sudo apt install -y docker.io
sudo systemctl enable --now docker

# Agregar usuario actual al grupo docker (evita usar sudo para docker)
echo "Agregando usuario al grupo docker..."
sudo usermod -aG docker $USER
newgrp docker

# Instalar Docker Compose
echo "Instalando Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificación de instalaciones
echo "Verificando instalación..."
python3 --version
docker --version
docker-compose --version

echo "Instalación completada."
