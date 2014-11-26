#!/bin/bash

date=`date -I`
error=0

#xe host-backup file-name=/mnt/samsung/VM_backups/VOO-XEN1.bak-$date host=fd253f33-7f02-42c5-923c-49983bac3e3d -u root -pw V-U+N1C_0

if [ $? == 1 ]; then
 ERROR=1
fi

xe host-backup file-name=/mnt/samsung/VM_backups/VOO-XEN2.bak-$date host=f9e06507-57b8-413d-9a92-310e573724bd -u root -pw V-U+N1C_0

if [ $? == 1 ]; then
 ERROR=1
fi

xe pool-dump-database file-name=/mnt/samsung/VM_backups/pool-dump-database-$date

if [ $? == 1 ]; then
 ERROR=1
fi

exit $ERROR


