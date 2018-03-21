#!/bin/bash

ROOT_PASSWORD=${ROOT_PASSWORD:-foobar}
DB_USER=${DB_USER:-batch}
DB_PASS=${DB_PASS:-cigma}
DB_NAME=${DB_NAME:-cigma2}

echo "Creating the routines"
cat /data/routines.sql|mysql --user=$DB_USER --password=$DB_PASS $DB_NAME
cat /data/grants.sql|mysql --user=root --password=$ROOT_PASSWORD $DB_NAME

