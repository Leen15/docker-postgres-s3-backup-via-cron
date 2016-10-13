#!/usr/bin/env ruby
require 'time'
require 'aws-sdk'
require 'fileutils'

bucket_name = ENV['AWS_BUCKET_NAME']
project_name = ENV['BACKUP_NAME']

time = Time.now.strftime("%Y-%m-%d-%H-%M-%S")
filename = "#{project_name}.#{time}.sql.dump.bz2"
filepath = "/tmp/#{filename}"

# Move the backup file from docker run
FileUtils.mv('/tmp/backup.sql.dump.bz2', filepath)

# verify file exists and file size is > 0 bytes
unless File.exists?(filepath) && File.new(filepath).size > 0
  raise "Database was not backed up"
end

AWS.config(region: ENV['AWS_REGION'])
s3 = AWS.s3
bucket = s3.buckets[bucket_name]
object = bucket.objects["#{project_name}/#{filename}"]
object.write(Pathname.new(filepath), {
  :acl => :private,
})

if object.exists?
  FileUtils.rm(filepath)
else
  raise "S3 Object wasn't created"
end


DAYS = ENV['AWS_KEEP_FOR_DAYS'] || 30
CHECK_TIME = DAYS * 24 * 60 * 60
objects = bucket.objects.select do |o|
  time = o.last_modified
  time < Time.now - CHECK_TIME
end
objects.each(&:delete)
