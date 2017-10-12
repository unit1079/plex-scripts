# !/bin/bash
# This script runs a remount, independently, for all SFTP mounts

./sftp-mount-check.sh cartoons
sleep 1
./sftp-mount-check.sh doc
sleep 1
./sftp-mount-check.sh movies
sleep 1
./sftp-mount-check.sh music
sleep 1
./sftp-mount-check.sh tv
sleep 1
exit