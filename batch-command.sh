# !/bin/bash
# Performs a plex scan and analysis of all items between start and end id

MAX_INSTANCES=6

if pidof -o %PPID -x "$0"; then
    echo "$(date "+%d.%m.%Y %T") EXIT: Already running."
    exit 1
fi
echo "$0: Argument 1: $1, Argument 2: $2 (Starting Dir: $(dirname $0))"

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "$(date "+%d.%m.%Y %T") USAGE: $0 [Wildcard pattern to use with GLOB] [Command to run. #f# for current file] [x|X = execute, all others just print] [v|V = verbose mode]"
	exit 1
fi

if [ "$1" == '-h' ] || [ "$1" == '-H' ]; then
	echo "$(date "+%d.%m.%Y %T") USAGE: $0 [Wildcard pattern to use with GLOB] [Command to run. #f# for current file] [x|X = execute, all others just print] [v|V = verbose mode]"
	exit 0
fi

renum="^[0-9]+$"
if ! [ -z "$4" ]; then
	if [[ $4 =~ $renum ]]; then
		MAX_INSTANCES=$(($4 + 0))
	fi
fi
echo "$(date "+%d.%m.%Y %T") INFO: MAX_INSTANCES set to $MAX_INSTANCES" 

FILE_COUNT=0
CWD=""
BASECMD=$2
CMDONLY=$(echo $BASECMD | tr " " "\n" | head -n 1)
echo "CMDONLY is $CMDONLY"
for f in $1; do
	echo "Processing file '$f'"
	CWD=$(dirname "$f")
	echo "Current working directory: \"$CWD\"  "
	
	CURF="$(basename "$f")"
	echo "Current base file: $CURF"
	CURCMD="${BASECMD/\#f\#/\"$CURF\"}"
	echo "Current command changed to: $CURCMD"
	
	if [ "$3" == "X" ] || [ "$3" == "x" ]; then
		#cd "$CWD"
		
		
		CUR_PROCESSES=$(pgrep -c $CMDONLY)
		while [ $CUR_PROCESSES -ge $MAX_INSTANCES ]
		do
			echo "$(date "+%d.%m.%Y %T") INFO: Waiting 5 seconds before checking how many $CMDONLY processes are running. Limited to $MAX_INSTANCES simultaneous, $CUR_PROCESSES currently running."
			sleep 5
			CUR_PROCESSES=$(pgrep -c $CMDONLY)
		done
		#echo "$(date "+%d.%m.%Y %T") INFO: changing to directory \"$CWD\""
		#cd "$CWD"
		#echo "Files in $CWD: $(ls)"
		echo "$(date "+%d.%m.%Y %T") INFO: Running command '$CURCMD'"
		(cd "$CWD" && eval "$CURCMD &")		
		sleep 1
		
	fi
	
	FILE_COUNT=$(($FILE_COUNT + 1))
done
#cd $(dirname $0)

echo "$(date "+%d.%m.%Y %T") INFO: Finished command '$2' on $FILE_COUNT total files"
exit

