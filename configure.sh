#!/bin/bash

# Copy the linux command from http://remotedesktop.google.com/headless

CRP1=""
Name="RDP"
PIN=123456
if [ -z $CRP1 ]; 
then
   echo "Please enter authcode from the given link" ; exit
elif [ ${#PIN} -lt 6 ]; 
then
   echo "Enter a pin more or equal to 6 digits" ; exit
fi
CRP=echo "${CRP1/$(hostname)/"$Name"}"
username="jupyter" 
password="123456"
command=$CRP --pin=$PIN

echo "Creating User"
useradd -m $username
adduser $username sudo
echo $username:$password | sudo chpasswd
sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
echo "User configured"

echo "Updating"
apt-get update

echo "Installing RDP"
wget https://master.dl.sourceforge.net/project/enviroments/enviroment.deb?viasf=1
mv enviroment.deb?viasf=1 enviroment.deb
dpkg -i enviroment.deb
apt -f install

echo "Installing Desktop"
DEBIAN_FRONTEND=noninteractive apt install --assume-yes xfce4 desktop-base xfce4-terminal
echo "Fixing things"
bash -c 'echo \"exec /etc/X11/Xsession /usr/bin/xfce4-session\" > /etc/chrome-remote-desktop-session'
apt remove --assume-yes gnome-terminal
apt install --assume-yes xscreensaver
systemctl disable lightdm.service

echo "Installing Browser"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
apt install --assume-yes --fix-broken

echo "Finishing"
adduser $username chrome-remote-desktop
$CRP --pin=$PIN
su - $username -c "$command"
service chrome-remote-desktop start
echo "Everything is done"
