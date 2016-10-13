# Docker Postgres backup to Amazon S3 via cron

This image dumps your postgres databases very hour,
compresses the dump using bz2 and uploads it to an
amazon S3 bucket. Backups older than 30 days (OR days defined in `AWS_KEEP_FOR_DAYS`) are
deleted automatically.

Configure the backup source and s3 target with these environment
variables:

- `AWS_REGION` (for example `eu-central-1`)
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_BUCKET_NAME`
- `AWS_KEEP_FOR_DAYS`
- `BACKUP_NAME`
- `PGHOST`
- `PGPORT`
- `PGUSER`
- `PGPASSWORD`


## Usage

If you wish to do postgres backups to s3 with [tutum](http://tutum.co)
or [docker compose](https://docs.docker.com/compose/), put this in your
`Stackfile`/`docker-compose.yml`:

```yaml
fitty-postgres-backup:
  image: 'jannis/postgres-s3-backup-via-cron'
  environment:
    - AWS_ACCESS_KEY_ID=<access key>
    - AWS_BUCKET_NAME=<your s3 bucket name>
    - AWS_REGION=<the region your bucket is in>
    - AWS_SECRET_ACCESS_KEY=< secret access key>
    - AWS_KEEP_FOR_DAYS=< how many days do you want to keep backups>
    - BACKUP_NAME=<this will be the directory containing your backups on s3>
    - PGHOST=<see the link section below>
    - PGUSER=<username>
    - PGPASSWORD=<password>
    - PGPORT=<this is usually 5432>
  links:
    - 'your-postgres-master-container:master'
```

The `links` section is optional, of course, just make sure you update the
`PGHOST` environment variable accordingly.


## Contribute

This image does backups every hour and just keeps everything of the past 30
days. It would be much better if this was configurable, if it would keep
1 backup per day for the past 30-60 days, and so on.

Also, it just dumps all the databases. Perhaps you just want some. That would
also be a nice thing to implement, that it can be configured which databases
should be backed up.

Just [fork this repo](https://help.github.com/articles/fork-a-repo/), implement
your changes and issue a PR. Don't be afraid if you're not sure how to do
things. Just send that PR over (or a message) and we'll figure it out together. 🤓


## Thanks

Adapted from [here](https://blog.danivovich.com/2015/07/23/postgres-backups-to-s3-with-docker-and-systemd/), [here](http://blog.oestrich.org/2015/01/pg-to-s3-backup-script/) and [here](https://www.ekito.fr/people/run-a-cron-job-with-docker/].
