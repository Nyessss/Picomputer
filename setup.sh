#!/bin/bash

# piComputer setup script
# https://github.com/qtaped

clear
echo "       _ _____                   _           "
echo "   ___|_|     |___ _____ ___ _ _| |_ ___ ___ "
echo "  | . | |   --| . |     | . | | |  _| -_|  _|"
echo "  |  _|_|_____|___|_|_|_|  _|___|_| |___|_|  "
echo "  |_|                   |_|                  "
echo
echo "  ..........................................."
echo
echo "This script will execute the tasks described here:"
echo "https://github.com/qtaped/picomputer/wiki/manual_installation"
echo

read -p ":: This will modify /boot/config.txt -- Continue? (y/n): " choice
case $choice in
  [Yy])
    # Make a backup of your config
    sudo mv /boot/config.txt /boot/config.txt.backup
    # Download & copy system/config.txt to /boot/
    sudo wget -L https://raw.githubusercontent.com/Nyessss/picomputer/main/system/config.txt -O /boot/firmware/config.txt
    echo "/boot/firmware/config.txt backup and updated."
    echo
    ;;
  *)
    echo "No changes were made to the configuration file."
    echo
    ;;
esac


read -p ":: Apply rotation to screen in console mode -- Continue? (y/n): " choice
case $choice in
  [Yy])
    # Append /boot/cmdline.txt
    sudo cp /boot/cmdline.txt /boot/cmdline.txt.backup
    sudo awk '{$0 = $0 " video=HDMI-A-1:480x1920,rotate=270"} 1' /boot/firmware/cmdline.txt | sudo tee /boot/firmware/cmdline.txt >/dev/null
    echo "/boot/firmware/cmdline.txt backup and updated."
    echo
    ;;
  *)
    echo "No changes were made."
    echo
    ;;
esac


echo ":: This will run <raspi-config>..."
echo
echo "Go to <Advanced Options> install <GL Driver> and choose <Full KMS>"
echo "finally, enable <Glamor> graphics acceleration."
echo
read -p "If raspi-config ask you if you want to reboot: DO NOT REBOOT. Continue? (y/n): " choice
case $choice in
  [Yy])
    # Do
    sudo raspi-config
    echo "raspi-config quit. continue."
    echo
    ;;
  *)
    echo "No changes were made."
    echo
    ;;
esac


read -p ":: Add 00-picomputer.conf for Xorg -- Continue? (y/n): " choice
case $choice in
  [Yy])
    sudo mkdir -p /usr/share/X11/xorg.conf.d
    sudo wget -L https://raw.githubusercontent.com/Nyessss/picomputer/main/system/00-picomputer.conf -O /usr/share/X11/xorg.conf.d/00-picomputer.conf
    echo "Ok."
    echo
    ;;
  *)
    echo "No changes were made."
    echo
    ;;
esac


CONFIG_FILE="/etc/default/console-setup"
FONTFACE="TerminusBold"
FONTSIZE="12x24"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file $CONFIG_FILE not found."
    echo
else
  read -p ":: Change FONTFACE and FONTSIZE values in $CONFIG_FILE -- Continue? (y/n): " choice
  case $choice in
    [Yy])
      # Update the FONTFACE and FONTSIZE values in the configuration file
      sudo sed -i "s/^FONTFACE=.*/FONTFACE=\"$FONTFACE\"/" "$CONFIG_FILE"
      sudo sed -i "s/^FONTSIZE=.*/FONTSIZE=\"$FONTSIZE\"/" "$CONFIG_FILE"
      sudo setupcon
      echo "Configuration file $CONFIG_FILE updated. FONTFACE set to $FONTFACE and FONTSIZE set to $FONTSIZE."
      echo
      ;;
    *)
      echo "No changes were made to the configuration file."
      echo
      ;;
  esac
fi


read -p ":: Do you want to download piComputer installer files? (y/n): " choice
case $choice in
  [Yy])
    wget --no-check-certificate -O $HOME/picomputer.zip https://github.com/Nyessss/picomputer/archive/refs/heads/main.zip
    unzip $HOME/picomputer.zip 
    chmod +x $HOME/picomputer-main/install.sh
    if [ ! -f "$HOME/picomputer-main/install.sh" ]; then
      echo "Error: File $HOME/picomputer-main/install.sh not found."
      echo
    else
      echo "Ok."
      echo
    fi
    ;;
  *)
    echo "No changes were made."
    echo
    ;;
esac


read -p ":: If all previous steps have been done, you have to reboot. Do you want to? (y/n): " choice
case $choice in
  [Yy])
      echo "After reboot, you can run the install script to configure your piComputer."
      sleep 3
      sudo reboot
      echo "bye."
      exit 0
      ;;
  *)
      echo "bye."
      exit 1
      ;;
esac

