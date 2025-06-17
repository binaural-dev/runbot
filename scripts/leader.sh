#!/bin/bash
set -e
exec python3 /opt/odoo/runbot/runbot_builder/leader.py \
    --odoo-path=/usr/lib/python3/dist-packages/odoo \
    --addons-path=${ADDONS_PATH} \
    -d ${DB_NAME:-runbot} \
    --db_host=${DB_HOST:-db} \
    --db_port=${DB_PORT:-5432} \
    --db_user=${DB_USER:-odoo} \
    --db_password=${DB_PASSWORD:-odoo} \
    --forced-host-name=${FORCED_HOST_NAME:-leader}
