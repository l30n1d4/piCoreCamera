#!/bin/sh

#ftp-upload.sh file.jpg file_big.jpg
#the 3G internet connection is slow (especially in upload), the images are uploaded with a temporary name and then renamed.

lftp << EOF
set ftp:ssl-allow no
open -u username,password ftp.server.altervista.org
lcd /home/tc
put $1 -o temp.jpg
mv temp.jpg $1
put $2 -o temp_big.jpg
mv temp_big.jpg $2
bye
EOF
