#!/bin/bash

# workdir=/home/$USER/odoo
# exec python3 $workdir/runbot/runbot_builder/builder.py --odoo-path $workdir/odoo -d runbot --logfile $workdir/logs/runbot_builder.txt --forced-host-name runbot.domain.com


# Variables
ODOO_DIR="/home/odoo"
LOGS_DIR="/home/odoo/custom_addons/runbot/logs"

RUNBOT_REPO_DIR="/home/odoo/custom_addons/runbot"

$DOMAIN="runbot2.binauraldev.com"

exec python3 $RUNBOT_REPO_DIR/runbot_builder/builder.py --odoo-path $ODOO_DIR -d runbot --logfile $LOGS_DIR/runbot_builder.txt --forced-host-name $DOMAIN
