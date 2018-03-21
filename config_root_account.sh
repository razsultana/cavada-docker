#!/bin/bash

ROOT_PASSWORD=${ROOT_PASSWORD:-foobar}

echo "Setting up root password."
mysqladmin -u root password $ROOT_PASSWORD

