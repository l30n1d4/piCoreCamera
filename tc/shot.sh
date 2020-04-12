#!/bin/sh

eval $(date +"G=%d; M=%m; A=%Y; ORE=%H; MIN=%M;")
IMAGE=fornovo.jpg
IMAGE_BIG=fornovo_big.jpg
GPS="-x GPS.GPSLatitude=44/1,39/1,11/1 -x GPS.GPSLongitude=10/1,5/1,26/1 -x GPS.GPSAltitude=500/1 -x GPS.GPSImgDirection=13/1"
TEXT_TOPLEFT="$G/$M/$A $ORE:$MIN | Fornovo di Taro (Parma) - 158m slm"
TEXT_TOPRIGHT="© Fabio Tozzi & Gianluca Vascelli"
LOGO="/home/tc/logo_mit.png"

#https://www.raspberrypi.org/documentation/raspbian/applications/camera.md
raspistill -w 640 -h 480 -n -ex night $GPS -o $IMAGE
raspistill -n -ex night $GPS -o $IMAGE_BIG

wget -O api.json http://meteofornovo.altervista.org/api.json
timeJson=`awk '/"time"/{print}' api.json | cut -d'"' -f 4`
outTemp=`awk '/"outTemp"/{print $1}' api.json | awk -F'"' '{print $NF}'`
windSpeed=`awk '/"windSpeed"/{print $1}' api.json | awk -F'"' '{print $NF}'`
windDir=`awk '/"windDirText"/{print $1}' api.json | cut -d'"' -f 4`
humidity=`awk '/"humidity"/{print $1}' api.json | cut -d'"' -f 4`
barometer=`awk '/"barometer"/{print $1}' api.json | awk -F'"' '{print $NF}'`
pm2_5=`awk '/"PM2_5"/{print $1}' api.json | awk -F'"' '{print $NF}'`
pm10=`awk '/"PM10"/{print $1}' api.json | awk -F'"' '{print $NF}'`

if [ -z "$timeJson" ]; then
  TEXT_BOTTOMLEFT="dati meteo non disponibili: visita https://meteofornovo.altervista.org"
  TEXT_BOTTOMLEFT_SMALL="dati meteo non disponibili: visita https://meteofornovo.altervista.org"
else
  TEXT_BOTTOMLEFT="Temperatura: $outTemp°C | Vento: $windSpeed Km/h dir. [$windDir] | Umidità: $humidity | Barometro: $barometer mbar | PM2.5: $pm2_5μg/m³  | PM10: $pm10μg/m³"
  TEXT_BOTTOMLEFT="${TEXT_BOTTOMLEFT} | https://meteofornovo.altervista.org"
  TEXT_BOTTOMLEFT_SMALL="Temperatura: $outTemp°C | Vento: $windSpeed Km/h | Umidità: $humidity | Barometro: $barometer mbar"
fi

#convert small image
convert $IMAGE \
        -gravity NorthWest -background Black -splice 0x18 \
        -gravity SouthWest -background Black -splice 0x18 \
        -gravity NorthWest -font "DejaVu-Sans-Condensed" -fill White -annotate +2+2 "$TEXT_TOPLEFT" \
        -gravity NorthEast -font "DejaVu-Sans-Condensed" -fill White -annotate +2+2 "$TEXT_TOPRIGHT" \
        -gravity SouthWest -font "DejaVu-Sans-Condensed" -fill White -annotate +2+2 "$TEXT_BOTTOMLEFT_SMALL" \
        $IMAGE

convert $IMAGE $LOGO \
        -gravity southeast -geometry 125x42+2+1 -composite \
        $IMAGE

#convert big image
convert $IMAGE_BIG \
        -gravity NorthWest -pointsize 68 \
        -stroke '#000C' -strokewidth 2 -font "DejaVu-Sans-Condensed" -annotate +2+4 "$TEXT_TOPLEFT" \
        -stroke none -fill White       -font "DejaVu-Sans-Condensed" -annotate +2+4 "$TEXT_TOPLEFT" \
        -gravity NorthEast -pointsize 40 \
        -stroke '#000C' -strokewidth 2 -font "DejaVu-Sans-Condensed" -annotate +2+4 "$TEXT_TOPRIGHT" \
        -stroke none -fill White       -font "DejaVu-Sans-Condensed" -annotate +2+4 "$TEXT_TOPRIGHT" \
        -gravity SouthWest -pointsize 40 \
        -stroke '#000C' -strokewidth 2 -annotate +2+4 "$TEXT_BOTTOMLEFT" \
        -stroke none -fill White       -annotate +2+4 "$TEXT_BOTTOMLEFT" \
        $IMAGE_BIG

convert $IMAGE_BIG $LOGO \
        -gravity southeast -geometry 200x67+2+1 -composite \
        $IMAGE_BIG

if [ $MIN == '00' ]; then
  NAME=$A$M$G"_"$ORE$MIN".jpg"
  sh /home/tc/ftp-nas.sh $IMAGE $NAME
  if [ $ORE == '12' ]; then
    NAME=$A$M$G"_00_"$ORE$MIN"_HD.jpg"
    sh /home/tc/ftp-nas.sh $IMAGE_BIG $NAME
  fi
fi

sh /home/tc/ftp-upload.sh $IMAGE $IMAGE_BIG

#printf "FINISH\n" >> $LOG
exit 0
