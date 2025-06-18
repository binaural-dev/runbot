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

# INSTALAR ODOO

#!/bin/bash

# Variables
ODOO_VERSION=17.0
ODOO_HOME=/opt/odoo
ODOO_USER=odoo
ODOO_REPO=https://github.com/odoo/odoo.git

# Actualizar el sistema e instalar dependencias
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-dev python3-venv libxml2-dev \
    libxslt1-dev libldap2-dev libsasl2-dev libpq-dev libjpeg-dev zlib1g-dev \
    libffi-dev libblas-dev liblapack-dev libatlas-base-dev

# Instalar PostgreSQL
# sudo apt install -y postgresql
# sudo systemctl enable postgresql
# sudo systemctl start postgresql

# Crear usuario de sistema para Odoo
sudo useradd -m -d $ODOO_HOME -s /bin/bash $ODOO_USER

# Configurar PostgreSQL para Odoo
sudo -u postgres createuser --superuser $ODOO_USER

# Descargar Odoo 17
sudo -u $ODOO_USER git clone --depth 1 --branch $ODOO_VERSION $ODOO_REPO $ODOO_HOME

# Crear entorno virtual y instalar dependencias
sudo -u $ODOO_USER python3 -m venv $ODOO_HOME/venv
sudo -u $ODOO_USER $ODOO_HOME/venv/bin/pip install wheel
sudo -u $ODOO_USER $ODOO_HOME/venv/bin/pip install -r $ODOO_HOME/requirements.txt

# Crear script de ejecución
cat <<EOF | sudo tee /etc/systemd/system/odoo.service
[Unit]
Description=Odoo
After=postgresql.service

[Service]
User=$ODOO_USER
ExecStart=$ODOO_HOME/venv/bin/python $ODOO_HOME/odoo-bin
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Activar y lanzar servicio
sudo systemctl daemon-reload
sudo systemctl enable odoo
sudo systemctl start odoo

echo "¡Instalación de Odoo 17 completada!"


# Verificación de instalaciones
echo "Verificando instalación..."
python3 --version
docker --version
docker-compose --version
odoo --version

echo "Instalación completada."
