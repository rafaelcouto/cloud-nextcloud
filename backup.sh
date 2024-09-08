#!/bin/bash

while getopts "p:" arg; do
  case $arg in
    p) password=$OPTARG;;
  esac
done


# Starting maintence mode
docker exec -u www-data nextcloud-nextcloud-app-1 php occ maintenance:mode --on

# Generating database backup
docker exec nextcloud-nextcloud-db-1 mariadb-dump --single-transaction -h localhost -u root -p$password nextcloud > "/home/rafael/nextcloud/dump/database.sql.gz"

# Stoping maintence mode
docker exec -u www-data nextcloud-nextcloud-app-1 php occ maintenance:mode --off
