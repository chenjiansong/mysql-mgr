#!/bin/bash

# start mysqld
docker-entrypoint.sh $@ &

# start xtrabackup if $XTRABACKUP = Y/y
if [[ "$XTRABACKUP" = "Y" || "$XTRABACKUP" = "y" ]]; then
	echo "starting xtrabackup..."
	cd /home/xtrabackup/cron/bin/
	./runBackup.sh & >> backup.log
	echo "xtrabackup started."
else
    echo "XTRABACKUP not set, xtrabackup will not run."
fi

# start xtrabackup for remote if $XTRABACKUP_REMOTE = Y/y
if [[ "$XTRABACKUP_REMOTE" = "Y" || "$XTRABACKUP_REMOTE" = "y" ]]; then
	echo "starting xtrabackup for remote..."
	cd /home/xtrabackup/cron/bin/
	./run_backup_remote.sh & >> backup_remote.log
	echo "xtrabackup for remote started."
else
    echo "XTRABACKUP_REMOTE not set, xtrabackup for remote will not run."
fi

# foreground process to keep container running
tail -f /var/log/mysql/error.log

