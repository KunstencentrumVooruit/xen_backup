#!/bin/bash

#
# Citrix XenServer 5.5 VM Backup Script
# This script provides online backup for Citrix Xenserver 5.5 virtual machines
#
# @version	3.01
# @created	24/11/2009
# @lastupdated	01/12/2009
#
# @author	Andy Burton
# @url		http://www.andy-burton.co.uk/blog/
# @email	andy@andy-burton.co.uk
#

# Get current directory

search=`find /mnt/samsung/parking -mtime +30 -type f`
if [ -n "$search" ]; then # files found
	find /mnt/samsung/parking -mtime +30 -type f -exec rm {} \;
	find /mnt/samsung/VM_backups/ -mtime +2 -type f -print0 | xargs -I{} -0 -exec mv -v {} /mnt/samsung/parking/  # -print0 & -0 optie bij Xargs dient om spaties in bestandsnamen op te vangen
fi

find /mnt/samsung/VM_backups/ -mtime +2 -type f -exec rm {} \;

dir=`dirname $0`

# Alle VMs die moeten gebackupped worden dienen een custom field 'backup=yes' te hebben (in te vullen via XenCenter).
# getVMs2backup is een perlscript dat de uuid parst op basis van dat veld, en het formatteert in de vorm van
# add_to_backup_list "<UUID>". In vm_backup.cfg wordt add_to_backup_list.sh ge-included.

/root/backup_VMs/getVMs2backup > /root/backup_VMs/add_to_backup_list.sh

# Load functions and config

. $dir"/vm_backup.lib"
. $dir"/vm_backup.cfg"


# Switch backup_vms to set the VM uuids we are backing up in vm_backup_list

case $backup_vms in
	
	"all")
		if [ $vm_log_enabled ]; then
			log_message "Backup All VMs"
		fi
		set_all_vms
		;;	
		
	"running")
		if [ $vm_log_enabled ]; then
			log_message "Backup running VMs"
		fi
		set_running_vms
		;;
		
	"list")
		if [ $vm_log_enabled ]; then
			log_message "Backup list VMs"
		fi
		;;
		
	*)
		if [ $vm_log_enabled ]; then
			log_message "Backup no VMs"
		fi
		reset_backup_list
		;;
	
esac


# Backup VMs

backup_vm_list

# Alle exports met de vermelding 'sun' worden gemoved naar de weekly directory
#find /mnt/samsung/VM_backups/weekly/ -mtime +15 -type f -exec rm {} \;
# Alle exports ouder dan 6 dagen worden verwijderd (geen 100% safe remove!!! 2do) 
#find /mnt/samsung/VM_backups/ -mtime +4 -type f -exec rm {} \;

# End

if [ $vm_log_enabled ]; then
	log_disable
fi

