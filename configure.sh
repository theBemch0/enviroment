#!/bin/bash

echo "Fixing things"
bash -c 'echo \"exec /etc/X11/Xsession /usr/bin/xfce4-session\" > /etc/chrome-remote-desktop-session'
apt remove --assume-yes gnome-terminal
apt install --assume-yes xscreensaver
systemctl disable lightdm.service