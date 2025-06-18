#!/bin/bash

set -e  # Detiene el script si hay un error

# Validación de Python, Docker y Docker Compose
echo "🔍 Verificando dependencias..."

# Verificar Python
if ! command -v python3 &>/dev/null; then
    echo "❌ Python no está instalado. Instálalo con: sudo apt install python3"
    exit 1
fi

# Verificar Docker
if ! command -v docker &>/dev/null; then
    echo "❌ Docker no está instalado. Instálalo con: sudo apt install docker.io"
    exit 1
fi

# Verificar Docker Compose
if ! command -v docker compose &>/dev/null && ! command -v docker-compose &>/dev/null; then
    echo "❌ Docker Compose no está instalado."
    echo "📌 Instálalo con:"
    echo "sudo apt install docker-compose"
    exit 1
fi

# Verificar PostgreSQL
if ! command -v psql &>/dev/null; then
    echo "❌ PostgreSQL no está instalado. Instálalo con: sudo apt install postgresql"
    exit 1
fi

# Verificar Odoo
if ! command -v odoo &>/dev/null; then
    echo "❌ Odoo no está instalado. Revisa la instalación manual o contenedores."
    exit 1
fi

# Mostrar versiones encontradas
echo "✅ Dependencias encontradas:"
echo "   - Python $(python3 --version)"
echo "   - Docker $(docker --version)"
echo "   - Docker Compose $(docker compose version 2>/dev/null || docker-compose --version)"
echo "   - PostgreSQL $(psql --version)"
echo "   - Odoo versión detectada"


# Variables
RUNBOT_USER="runbot"
ODOO_DIR="/home/$RUNBOT_USER/odoo"
LOGS_DIR="/home/$RUNBOT_USER/logs"
BIN_DIR="/home/$RUNBOT_USER/bin"
RUNBOT_REPO="git@github.com:binaural-dev/runbot.git"
RUNBOT_REPO_DIR="$ODOO_DIR/runbot"
ODOO_REPO="git@github.com:odoo/odoo.git"
ODOO_REPO_DIR="$ODOO_DIR/odoo"
BRANCH="17.0"

RUNBOT_SH_SCRIPTS_DIR="$BIN_DIR/runbot"

$DOMAIN="runbot2.binauraldev.com"

# Mostrar Variables utilizadas
echo "✅ Dependencias encontradas:"
echo "   - RUNBOT_USER $(RUNBOT_USER)"
echo "   - ODOO_DIR $(docker --version)"
echo "   - Docker Compose $(docker compose version 2>/dev/null || docker-compose --version)"
echo "   - PostgreSQL $(psql --version)"
echo "   - Odoo versión detectada"

# Crear usuario runbot
echo "📌 Creando usuario '$RUNBOT_USER'..."
sudo adduser --disabled-password --gecos "" "$RUNBOT_USER"

# Configurar permisos en Docker y PostgreSQL
echo "🛠 Configurando permisos..."
sudo -u postgres createuser -d "$RUNBOT_USER"
sudo adduser "$RUNBOT_USER" docker
sudo systemctl restart docker

# Preparar entorno
echo "📂 Creando directorios..."
sudo -u "$RUNBOT_USER" mkdir -p "$ODOO_DIR" # Folder /home/runbot/odoo
sudo -u "$RUNBOT_USER" mkdir -p "$LOGS_DIR" # Folder /home/runbot/logs

# Clonar repositorios
echo "🔄 Clonando repositorios..."
sudo -u "$RUNBOT_USER" git clone --depth=1 --branch="$BRANCH" "$ODOO_REPO" "$ODOO_REPO_DIR" # Clone on /home/runbot/odoo/odoo
sudo -u "$RUNBOT_USER" git clone "$RUNBOT_REPO" "$RUNBOT_REPO_DIR" # Clone on /home/runbot/odoo/runbot

# Asegurar que odoo y runbot estén en la version correcta
sudo -u "$RUNBOT_USER" git -C "$ODOO_REPO_DIR" checkout "$BRANCH"
sudo -u "$RUNBOT_USER" git -C "$RUNBOT_REPO_DIR" checkout "$BRANCH"

# Configurar scripts
echo "⚙️ Configurando scripts..."
sudo -u "$RUNBOT_USER" mkdir -p "$BIN_DIR"
sudo -u "$RUNBOT_USER" cp -r "$RUNBOT_REPO_DIR/runbot/runbot/example_scripts/runbot" "$RUNBOT_SH_SCRIPTS_DIR" # On Folder /home/{runbot_user}/bin/runbot

# Modificar builder.sh con el dominio correcto
echo "📝 Modificando builder.sh..."
sudo -u "$RUNBOT_USER" sed -i "s/runbot.domain.com/runbot.$DOMAIN/" "$RUNBOT_SH_SCRIPTS_DIR/builder.sh"

# Configurar servicios
echo "🔧 Configurando servicios..."
sudo bash -c "cp $RUNBOT_REPO_DIR/runbot/runbot/example_scripts/services/* /etc/systemd/system/"
sudo sed -i "s/runbot_user/${RUNBOT_USER}/" "/etc/systemd/system/runbot.service"
sudo sed -i "s/runbot_user/${RUNBOT_USER}/" "/etc/systemd/system/leader.service"
sudo sed -i "s/runbot_user/${RUNBOT_USER}/" "/etc/systemd/system/builder.service"

# Habilitar servicios y arrancar Runbot
echo "🚀 Iniciando servicios..."
# Habilitar servicios para que se inicie automáticamente en el arranque del sistema
sudo systemctl enable runbot
sudo systemctl enable leader
sudo systemctl enable builder

# recargar la configuración de systemd sin reiniciar el sistema
sudo systemctl daemon-reload

# Iniciar un servicios manualmente
sudo systemctl start runbot
sudo systemctl start leader
sudo systemctl start builder

# Verificar estado
echo "🔍 Verificando estado..."
sudo systemctl status runbot --no-pager
