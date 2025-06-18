#!/bin/bash

set -e  # Detiene el script si hay un error

echo "🔍 Validando instalación de Runbot y dependencias..."

# Variables
RUNBOT_USER="runbot"
ODOO_DIR="/home/$RUNBOT_USER/odoo"
RUNBOT_REPO_DIR="$ODOO_DIR/runbot"
ODOO_REPO_DIR="$ODOO_DIR/odoo"
SERVICES=("runbot" "leader" "builder")
DEP_PROGRAMS=("python3" "docker" "docker-compose" "psql" "odoo")

# Verificar dependencias instaladas
echo "🛠 Verificando dependencias..."
for program in "${DEP_PROGRAMS[@]}"; do
    if ! command -v "$program" &>/dev/null; then
        echo "❌ Dependencia faltante: $program"
        exit 1
    else
        echo "✅ $program encontrado: $($program --version 2>/dev/null || echo '✔ Disponible')"
    fi
done

# Verificar existencia de directorios clave
echo "📂 Verificando directorios..."
for dir in "$ODOO_DIR" "$RUNBOT_REPO_DIR" "$ODOO_REPO_DIR"; do
    if [ ! -d "$dir" ]; then
        echo "❌ Directorio faltante: $dir"
        exit 1
    fi
done
echo "✅ Todos los directorios existen."

# Verificar repositorios clonados correctamente
echo "🔄 Verificando repositorios..."
for repo_dir in "$RUNBOT_REPO_DIR/.git" "$ODOO_REPO_DIR/.git"; do
    if [ ! -d "$repo_dir" ]; then
        echo "❌ Repositorio no encontrado en $(dirname "$repo_dir")"
        exit 1
    fi
done
echo "✅ Repositorios verificados."

# Verificar estado de servicios
echo "🔧 Verificando servicios..."
for service in "${SERVICES[@]}"; do
    if ! systemctl is-active --quiet "$service"; then
        echo "❌ Servicio $service no está corriendo."
        exit 1
    else
        echo "✅ Servicio $service en ejecución."
    fi
done

# Verificar puertos abiertos (Ejemplo: Puerto por defecto de Odoo 8069)
echo "🌐 Verificando puertos..."
if ! netstat -tulnp | grep -q ":8069"; then
    echo "❌ Odoo no está escuchando en el puerto 8069."
    exit 1
fi
echo "✅ Odoo está activo en el puerto 8069."

# Validar acceso a PostgreSQL
echo "🗄️ Verificando conexión a PostgreSQL..."
if sudo -u postgres psql -c '\q' 2>/dev/null; then
    echo "✅ Conexión a PostgreSQL establecida."
else
    echo "❌ No se pudo conectar a PostgreSQL. Verifica configuración."
    exit 1
fi

echo "🎉 Validación completada con éxito. Runbot está funcionando correctamente."
