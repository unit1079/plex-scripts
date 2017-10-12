#rclone mount enc: /home/plex/enc --config /home/plex/.rclone.conf --allow-other &
#rclone mount --allow-other --allow-non-empty --read-only --max-read-ahead 1G --acd-templink-threshold 0 --config /home/plex/.rclone.conf enc: /home/plex/enc &

umount -f /home/sftp/sftpguest/shared/movies
umount -f /home/sftp/sftpguest/shared/music
umount -f /home/sftp/sftpguest/shared/tv
umount -f /home/sftp/sftpguest/shared/docs
mount --bind /home/plex/enc/movies /home/sftp/sftpguest/shared/movies -o ro
mount --bind /home/plex/enc/music /home/sftp/sftpguest/shared/music -o ro
mount --bind /home/plex/enc/tv /home/sftp/sftpguest/shared/tv -o ro
mount --bind /home/plex/enc/doc /home/sftp/sftpguest/shared/docs -o ro

exit
