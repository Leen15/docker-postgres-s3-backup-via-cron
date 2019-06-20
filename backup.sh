#!/bin/bash
echo "`date` ~~~~~~~~~~~ STARTING BACKUP ~~~~~~~~~~~~"
rm -f /tmp/backup.sql.dump.bz2
# echo "Config:"
# echo "  - AWS_REGION=${AWS_REGION}"
# echo "  - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"
# echo "  - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"
# echo "  - AWS_BUCKET_NAME=${AWS_BUCKET_NAME}"
# echo "  - BACKUP_PATH=${BACKUP_PATH}"
# echo "  - PGHOST=${PGHOST}"
# echo "  - PGDATABASE=${PGDATABASE}"
# echo "  - PGPORT=${PGPORT}"
# echo "  - PGUSER=${PGUSER}"
# echo "  - PGPASSWORD=${PGPASSWORD}"

echo "`date` Creating postgres dump"
if [ -f /tmp/backup.sql.dump ]; then
  echo "Dump in progress, aborting..."
  exit 0
fi
[ -z "$PGDATABASE" ] && CMD=pg_dumpall || CMD="pg_dump ${PGDATABASE}"
$BACKUP_PRIORITY $CMD > /tmp/backup.sql.dump

echo "`date` Compressing dump"
FILENAME=$PGDATABASE.$(date +"%Y-%m-%d-%H-%M-%S").sql.dump
mv /tmp/backup.sql.dump /tmp/$FILENAME
lbzip2 /tmp/$FILENAME

echo "`date` Uploading to S3"
/backup/s3upload.rb /tmp/$FILENAME.bz2
echo "`date` Done!"
