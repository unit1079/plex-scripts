# !/bin/bash
# Performs a plex scan and analysis of all items between start and end id

PLEXPATH="/usr/lib/plexmediaserver"
PLEXTOKEN="AD9VyBbzXuiWNxxGY7J4"
CLIENTID="dnqwadfx4p8netvrps7adobt9"
BASEURL="https://159-203-93-193.182998b73ebd46b0a311ab0f1c73da10.plex.direct:32400/library/metadata"
ACTIONURL="analyze?X-Plex-Token=$PLEXTOKEN&X-Plex-Client-Identifier=$CLIENTID"

if pidof -o %PPID -x "$0"; then
    echo "$(date "+%d.%m.%Y %T") EXIT: Already running."
    exit 1
fi

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "$(date "+%d.%m.%Y %T") EXIT: Missing required parameters: Start Item ID, End Item ID"
	exit 1
fi

renum="^[0-9]+$"
if ! [[ $1 =~ $renum ]]; then
	echo "$(date "+%d.%m.%Y %T") EXIT: Specified argument 1: '$1' is not a valid integer"
	exit 1
fi
if ! [[ $2 =~ $renum ]]; then
	echo "$(date "+%d.%m.%Y %T") EXIT: Specified argument 2: '$2' is not a valid integer"
	exit 1
fi
if [[ $1 -gt $2 ]]; then
	echo "$(date "+%d.%m.%Y %T") EXIT: Starting item ID must be less than or equal to ending item ID"
	exit 1
fi
export LD_LIBRARY_PATH="/usr/lib/plexmediaserver" 
LANG="en_US.UTF-8"
export PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS="6"
export PLEX_MEDIA_SERVER_TMPDIR="/tmp"
export PLEX_MEDIA_SERVER_HOME="/usr/lib/plexmediaserver"
export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="/var/lib/plexmediaserver/Library/Application Support"

echo "$(date "+%d.%m.%Y %T") INFO: Generating and analyzing items $1 to $2"
ci=$1
while [[ $ci -le $2 ]]
do
	echo "$(date "+%d.%m.%Y %T") INFO: Processing item $ci. $(($2 - $ci)) items remaining."
	#$PLEXPATH/./Plex\ Media\ Scanner -g -o $ci
	#$PLEXPATH/./Plex\ Media\ Scanner -a -o $ci
	curl -X PUT "$BASEURL/$ci/$ACTIONURL" -v
	ci=$(($ci + 1))
done
cnt=$(($2-$1+1))
echo "$(date "+%d.%m.%Y %T") INFO: Finished analyzing $cnt items"
exit