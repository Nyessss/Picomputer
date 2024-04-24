Rpi5 X1202

# Picomputer

```
     _ _____                   _           
 ___|_|     |___ _____ ___ _ _| |_ ___ ___ 
| . | |   --| . |     | . | | |  _| -_|  _|
|  _|_|_____|___|_|_|_|  _|___|_| |___|_|  
|_|                   |_|                  

```

## Ingredients
Raspberry pi 5
Geekworm X1202 UPS
M.2 SSD PCIe NVME 1To 2280
Argon THRML 200mm active cooler

18650x4 3.7V 3500mAh : .75V - 4.2V 65.5mmx18.5mm Lii35AType 
8.8' 420x1280 screen
2xSpeakers

## Rpi imager 
Raspberry pi imager - Bookworm 64 bits desktop Lite
    First boot and reboot
SSH
sudo raspi-config
  activate : I2C, BOOT ORDER.

## Eeprom update, enable PCIe connector - setup.sh

sudo apt update
sudo apt upgrade
rpi-eeprom-update -a

sudo rpi-eeprom-config --edit

BOOT_UART=1
POWER_OFF_ON_HALT=1
BOOT_ORDER=0xf416
PSU_MAX_CURRENT=5000

sudo nano /boot/firmware/config.txt
  & add lines:

dtparam=pciex1
dtparam=nvme
dtparam=pciex1_gen=3

reboot
sudo lspci
vcgencmd bootloader_version

(the bit 6 at end force NVMe boot or check in sudo raspi-config, advanced fuctions, boot order.)

## SETTING UP
via SSH
  bash -c "$(curl https://raw.githubusercontent.com/Nyessss/picomputer/main/setup.sh)"

bluetoothctl for mouse and keyboard
clone SD to Nvme

  
## X1202 
git clone https://github.com/suptronics/x120x.git
sudo i2cdetect -y 1

to run ~/x120x $  sudo python3 bat.py 
to edit  safe shutown (cf. code Q avec notifications) defaut <3.20V> voltage range must be 3.00 to 4.10V.
sudo nano bat.py 

power loss detection (cf. Code Q battery.py) 
sudo python3 pld.py

