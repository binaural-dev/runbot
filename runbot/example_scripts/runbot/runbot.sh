#!/bin/bash
# workdir=/home/$USER/odoo
# exec python3 $workdir/odoo/odoo-bin --workers=2 --without-demo=1 --max-cron-thread=1 --addons-path $workdir/odoo/addons,$workdir/runbot -d runbot --logfile $workdir/logs/runbot.txt

# Variables

ODOO_DIR="/home/odoo"
LOGS_DIR="/home/odoo/custom_addons/runbot/logs"

RUNBOT_REPO_DIR="/home/odoo/custom_addons/runbot"

$DOMAIN="runbot2.binauraldev.com"

$ADDONS="/home/odoo/addons,/home/odoo/custom_addons,$RUNBOT_REPO_DIR"

exec python3 $ODOO_DIR/odoo-bin --workers=2 --without-demo=1 --max-cron-thread=1 --addons-path $ADDONS -d runbot --logfile $LOGS_DIR/runbot.txt
