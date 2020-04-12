#!/bin/sh

#ftp-nas.sh file.jpg name_file_to_rename.jpg

Y=`date "+%Y"`
M=`date "+%m"`
D=`date "+%d"`

lftp << EOF
set ftp:ssl-allow no
open -u username,password server.dyndns.org
cd Web/meteo/meteofornovo/webcam
mkdir $Y
cd $Y
mkdir $M
cd $M
mkdir $D
cd $D
put $1 -o $2
bye
EOF
