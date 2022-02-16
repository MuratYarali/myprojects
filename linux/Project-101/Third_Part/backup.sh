#!/bin/bash

# Check if we are root privilage or not
if [[ $EUID -ne 0 ]]; then
   sudo su "Please use this bash script with root privilage"
   exit
fi

# Which files are we going to back up. Please make sure to exist /home/ec2-user/data file
backup_files="/home/ec2-user/data /etc /boot /usr"

# Where do we backup to. Please crete this file before execute this script
dest="/mnt/backup"

# Create archive filename based on time
time=$(date +"%Y_%m_%d_%I_%M_%p")
hostname=$(hostname -s)
archive_file=$hostname-$time

# Print start status message.
echo "We will back up $backup_files to $dest/$archive_file"

# Backup the files using tar.
tar czf $dest/$archive_file $backup_files

# Print end status message.
echo "Congradulations. Your Backup is ready"

# Long listing of files in $dest to check file sizes.
ls -h $dest

# According to the project this bash script will be executed in every 5 minutes via crontab.