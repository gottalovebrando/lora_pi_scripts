#!/bin/bash
#run this for a fresh OS install to setup
#V1.0-initial version, WORK IN PROGRESS, manual setup of some items still needed

echo "please manually do these things:"
echo "--remove desktop background"
echo "--enable internet connection method if not using ethernet (such as wifi credentials)"
echo "--enable SSH server & enable serial, disable serial console, set headless screen resolution to maxium. Do this in sudo raspi-config"
echo "--change password with passwd"
echo "--Determine what number host we are on and replace NNNNN with that number set hostname by editing /etc/hostname (by simply replacing the entire file with get-aboutNNNNN) and /etc/hosts (by looking for line with 127.0.0.1 and replacing the old hostname on that line with get-aboutNNNNN)."
#reboot friday (dow=5, sunday is 0 and 7) at 2:10 am)
echo "--Run sudo crontab -e and manually add this line to the bottom: '10 2 * * 5 /usr/sbin/reboot'"

#install support programs
sudo apt update && sudo apt upgrade -y
sudo apt install git -y
#nice to have but not required:
#sudo apt install tmux atop -y
wget https://download.teamviewer.com/download/linux/teamviewer_armhf.deb
sudo dpkg -i teamviewer_armhf.deb
sudo apt-get install -f
sudo dpkg -i teamviewer_armhf.deb

#install the software to make it a base station
cd ~
sudo mkdir /opt/lora_logger
sudo chown $(whoami) /opt/lora_logger
echo "please manually clone the git repo to here /opt/lora_logger"
#@TODO- make cloning easy with git
read -rp "Press Enter to continue..."
chmod 777 set_permissions.sh
#set permissions with script
./set_permissions.sh
#set programs to start at boot
sudo cp /opt/lora_logger/for_new_OS/lora_startup.service /etc/systemd/system/lora_startup.service
sudo systemctl daemon-reload
sudo systemctl enable lora_startup.service
sudo systemctl start lora_startup.service
#sudo reboot
echo "please make sure this is saving serial data:"
journalctl -u  lora_startup
read -rp "Press Enter to continue..."

echo "please manually run stabilityTest.sh while logging data to ensure the system is working properly with your power supply, temperature, etc"
