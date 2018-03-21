#!/bin/bash

ROOT_PASSWORD=${ROOT_PASSWORD:-foobar}
DB_NAME=${DB_NAME:-cigma2}

__import_mysql_dump() {
    echo "Importing the dump of the mysql database"
    bzcat /data/cavada.sql.bz2|mysql --user=root --password=$ROOT_PASSWORD $DB_NAME
}

__import_mysql_dump

