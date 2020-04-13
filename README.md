# piCoreCamera
Raspberry Pi + piCore + Camera

## Requirements
- Raspberry Pi
- Raspberry Pi Camera Module

## Set up PiCore Linux
download [piCore](http://distro.ibiblio.org/tinycorelinux/9.x/armv6/releases/RPi/piCore-9.0.3.zip) and flash

## Expand the /dev/mmcblk0p2 Partition
    $ sudo fdisk -u /dev/mmcblk0
p
> print partizioni

d
> delete partizione di tipo 2

n
> nuova partizione di tipo 2

xxxxx
> usare l'ultimo settore del primo blocco

w
> per scrivere

    $ sudo reboot
    $ sudo resize2fs /dev/mmcblk0p2
    $ df -h
    $ sudo reboot

## Set up Raspberry Pi with PiCore Linux
    $ tce-load -wi nano.tcz
    $ tce-load -wi lftp.tcz
    $ tce-load -wi imagemagick.tcz
    $ tce-load -wi dejavu-fonts-ttf.tcz

## Set up Camera Module
    $ tce-load -wi rpi-vc.tcz
    $ sudo echo "chmod 777 /dev/vchiq" >> /opt/bootlocal.sh
    $ sudo mount /dev/mmcblk0p1 /mnt/mmcblk0p1
    $ sudo echo "gpu_mem=128" >> /mnt/mmcblk0p1/config.txt
    $ sudo echo "start_file=start_x.elf" >> /mnt/mmcblk0p1/config.txt
    $ sudo echo "fixup_file=fixup_x.dat" >> /mnt/mmcblk0p1/config.txt
    $ sudo filetool.sh -b
    $ sudo reboot

## sistemare l'orario corretto tramite:
    $ sudo mount /dev/mmcblk0p1 /mnt/mmcblk0p1
    $ sudo nano /mnt/mmcblk0p1/cmdline.txt
add at the end `tz=CET-1CEST,M3.5.0,M10.5.0/3 cron`

    $ sudo echo "TZ=CET-1CEST,M3.5.0,M10.5.0/3" > /etc/sysconfig/timezone
    $ echo "etc/sysconfig/timezone" >> /opt/.filetool.lst
    $ sudo filetool.sh -b
    $ sudo reboot

## sistemare cron
    $ sudo echo "cron -L /dev/null 2>&1" >> /opt/bootlocal.sh
    $ sudo filetool.sh -b
    $ sudo reboot
    $ crontab -e
add at the end `*/10 * * * * sh /home/tc/shot.sh`

    $ echo "var/spool/cron/crontabs" >> /opt/.filetool.lst
    $ sudo filetool.sh -b

## salvere gli script
    $ wget https://raw.githubusercontent.com/l30n1d4/piCoreCamera/master/tc/shot.sh
    $ wget https://raw.githubusercontent.com/l30n1d4/piCoreCamera/master/tc/ftp-upload.sh
    $ wget https://raw.githubusercontent.com/l30n1d4/piCoreCamera/master/tc/ftp-nas.sh
    $ chmod +x shot.sh
    $ chmod +x ftp-upload.sh
    $ chmod +x ftp-nas.sh
edit username e password in `ftp-upload.sh` and `ftp-nas.sh`

## salvare tutte le configurazioni effettuate
    $ sudo filetool.sh -b

## Thank's to
https://github.com/frederikheld/treecam
https://www.novaspirit.com/2018/01/09/tiny-core-raspberry-pi-zero-w-install/
https://www.youtube.com/watch?v=aKvW59uk4PY
