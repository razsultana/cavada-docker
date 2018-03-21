#!/bin/bash

rm -rf /var/lib/mysql
mysqld --initialize-insecure=on
chown -R mysql:mysql /var/lib/mysql
