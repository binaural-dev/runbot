#!/bin/bash

set -e  # Detiene el script si hay un error

# Validación de Python, Docker y Docker Compose
echo "🔍 Verificando dependencias..."


if ! command -v python3 &>/dev/null; then
    echo "❌ Python no está instalado. Instálalo con: sudo apt install python3"
    exit 1
fi

VERSION=$(python3 -V 2>&1)
if [[ "$VERSION" != "Python 3.10.12" ]]; then
    echo "⚠️ Se requiere Python 3.10.12, pero se encontró: $VERSION"
    echo "🔧 Puedes instalarlo manualmente o usar pyenv, por ejemplo:"
    echo "   curl https://pyenv.run | bash"
    echo "   pyenv install 3.10.12 && pyenv global 3.10.12"
    exit 1
fi

# Verificar si git está instalado
if ! command -v git &>/dev/null; then
    echo "❌ Git no está instalado. Puedes instalarlo con:"
    echo "   sudo apt install git"
    exit 1
fi

echo "✅ Entorno listo con Python 3.10.12 y Git instalados."

# Crear usuario odoo
echo "📌 Creando usuario 'odoo'..."
sudo adduser --disabled-password --gecos "" "odoo"
sudo -u postgres createuser -d "odoo"
# 
git clone https://github.com/odoo/odoo.git