#!/bin/bash
# workdir=/home/$USER/odoo
# exec python3 $workdir/odoo/odoo-bin --workers=2 --without-demo=1 --max-cron-thread=1 --addons-path $workdir/odoo/addons,$workdir/runbot -d runbot --logfile $workdir/logs/runbot.txt

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

workdir="$RUNBOT_REPO_DIR"

exec python3 $ODOO_REPO_DIR/odoo-bin --workers=2 --without-demo=1 --max-cron-thread=1 --addons-path $ODOO_REPO_DIR/addons,$RUNBOT_REPO_DIR -d runbot --logfile $LOGS_DIR/runbot.txt
