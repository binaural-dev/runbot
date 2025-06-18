#!/bin/bash

# workdir=/home/$USER/odoo
# exec python3 $workdir/runbot/runbot_builder/builder.py --odoo-path $workdir/odoo -d runbot --logfile $workdir/logs/runbot_builder.txt --forced-host-name runbot.domain.com


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

exec python3 $RUNBOT_REPO_DIR/runbot_builder/builder.py --odoo-path $ODOO_DIR -d runbot --logfile $LOGS_DIR/runbot_builder.txt --forced-host-name $DOMAIN
