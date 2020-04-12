# piCoreCamera
Raspberry Pi + piCore + Camera

## Requirements

- Raspberry Pi
- Raspberry Pi Camera Module

## Set up Raspberry Pi with PiCore Linux

    $ ssh tc@box

    $ tce-load -wi nano.tcz
    $ tce-load -wi lftp.tcz
    $ tce-load -wi rpi-vc.tcz
    $ chmod 777 /dev/vchiq
