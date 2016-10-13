#!/bin/bash

# change cron schedule
sed -i "s,CRON_SCHEDULE*,${BACKUP_CRON_SCHEDULE},g" /etc/cron.d/backup-cron

# Collect environment variables set by docker
env | egrep '^AWS|^PG|^BACKUP' | sort > /tmp/backup-cron
cat /etc/cron.d/backup-cron >> /tmp/backup-cron
mv /tmp/backup-cron /etc/cron.d/backup-cron


cron  && tail -f /var/log/cron.log
