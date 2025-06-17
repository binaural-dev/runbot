#!/bin/bash
set -e
exec odoo --workers=2 --without-demo=1 --max-cron-threads=1 \
    --addons-path=${ADDONS_PATH} \
    -d ${DB_NAME:-runbot} \
    --db_host=${DB_HOST:-db} \
    --db_port=${DB_PORT:-5432} \
    --db_user=${DB_USER:-odoo} \
    --db_password=${DB_PASSWORD:-odoo}
