#!/bin/bash

DB_NAME=${DB_NAME:-cigma2}
DB_USER=${DB_USER:-batch}
DB_PASS=${DB_PASS:-cigma}

echo "Creating the views"
cat /data/create_tgp_pop_main_view.sql|mysql --user=$DB_USER --password=$DB_PASS $DB_NAME
cat /data/create_tgp_phase3_pop_main_view.sql|mysql --user=$DB_USER --password=$DB_PASS $DB_NAME

