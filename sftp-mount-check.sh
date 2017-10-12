# !/bin/bash
# This script expects the name of the mount you want to check

LOGFILE="/home/plex/logs/sftp-mount-check.log"
RCLONEMOUNT="/home/plex/rgde"
SFTPMOUNTROOT="/home/sftp/sftpguest/shared"
MNT=$1
MPOINT=$SFTPMOUNTROOT/$MNT
RPOINT=$RCLONEMOUNT/$MNT
CHECKDIR="$(ls $RPOINT | head -1)"

echo "$(date "+%d.%m.%Y %T") Checking mount $MPOINT for folder $CHECKDIR" | tee -a "$LOGFILE"
if pidof -o %PPID -x "$0"; then
    echo "$(date "+%d.%m.%Y %T") EXIT: Already running." | tee -a "$LOGFILE"
    exit 1
fi

# echo "Running check for existence of '$MPOINT/$CHECKDIR'" | tee -a "$LOGFILE"
echo "Running non-empty check of '$MPOINT'" | tee -a "$LOGFILE"
if [[ -z "$(ls -A $MPOINT)" ]]; then
    echo "$(date "+%d.%m.%Y %T") ERROR: $MPOINT not mounted, remount in progress." | tee -a "$LOGFILE"
	
    # Unmount before remounting
    while mount | grep "on ${MPOINT} type" > /dev/null
    do
        echo "($wi) Unmounting $mount"
        fusermount -uz $MPOINT | tee -a "$LOGFILE"
        cu=$(($cu + 1))
        if [ "$cu" -ge 5 ];then
            echo "$(date "+%d.%m.%Y %T") ERROR: Folder could not be unmounted exit" | tee -a "$LOGFILE"
            exit 1
            break
        fi
        sleep 1
			
    done
	echo "Attempting command 'bindfs $RPOINT $MPOINT -o ro -o allow_other'" | tee -a "$LOGFILE"
    bindfs $RPOINT $MPOINT -o ro -o allow_other

    while ! mount | grep "on ${MPOINT} type" > /dev/null
    do
        echo "($wi) Waiting for mount $mount"
        c=$(($c + 1))
        if [ "$c" -ge 4 ] ; then break ; fi
        sleep 1
    done
    if [[ -z "$(ls -A $MPOINT)" ]]; then
		echo "$(date "+%d.%m.%Y %T") CRITICAL: Remount failed." | tee -a "$LOGFILE"        
    else
		echo "$(date "+%d.%m.%Y %T") INFO: Remount successful." | tee -a "$LOGFILE"		
    fi
else
	echo "$(date "+%d.%m.%Y %T") INFO: Check successful, $MPOINT mounted." | tee -a "$LOGFILE"
    exit    
fi
exit