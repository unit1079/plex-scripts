# !/bin/bash
# This script expects the name of the mount you want to check

if [[ -d "$1" ]]; then
    echo "Directory $1 exists!"
    exit
else
    echo "Directory $1 not found!"	
fi
exit