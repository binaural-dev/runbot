#!/bin/bash

# workdir=/home/$USER/odoo/
# exec python3 $workdir/runbot/runbot_builder/leader.py --odoo-path $workdir/odoo -d runbot --logfile $workdir/logs/runbot_leader.txt --forced-host-name=leader

ODOO_DIR="/home/odoo"
LOGS_DIR="/home/odoo/custom_addons/runbot/logs"

RUNBOT_REPO_DIR="/home/odoo/custom_addons/runbot"

DOMAIN="runbot2.binauraldev.com"


exec python3 $RUNBOT_REPO_DIR/runbot_builder/leader.py --odoo-path $ODOO_DIR -d runbot --logfile $LOGS_DIR/runbot_leader.txt --forced-host-name=leader
