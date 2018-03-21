#!/bin/bash

ROOT_PASSWORD=${ROOT_PASSWORD:-foobar}
DB_NAME=${DB_NAME:-cigma2}
DB_USER=${DB_USER:-batch}
DB_PASS=${DB_PASS:-cigma}

echo "Setting up new DB and user credentials."
mysql --user=root --password=$ROOT_PASSWORD -e "CREATE DATABASE $DB_NAME"
mysql --user=root --password=$ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS'; FLUSH PRIVILEGES;"
mysql --user=root --password=$ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS'; FLUSH PRIVILEGES;"
mysql --user=root --password=$ROOT_PASSWORD -e "select user, host FROM mysql.user;"
