#!/bin/bash

while getopts "p:" arg; do
  case $arg in
    p) password=$OPTARG;;
  esac
done

TARGET_DIR="/home/rafael/nextcloud/dump"

# Starting maintence mode
docker exec -u www-data nextcloud-nextcloud-app-1 php occ maintenance:mode --on

# Generating database backup
timestamp=$(date +"%Y%m%d%H%M%S")
docker exec nextcloud-nextcloud-db-1 mariadb-dump --single-transaction -h localhost -u root -p$password nextcloud > "$TARGET_DIR/$timestamp.sql.gz"

# Mantém apenas os últimos 7 backups
ls -tp "$TARGET_DIR"/*.sql.gz 2>/dev/null | grep -v '/$' | tail -n +8 | xargs -r rm --

# Stoping maintence mode
docker exec -u www-data nextcloud-nextcloud-app-1 php occ maintenance:mode --off
