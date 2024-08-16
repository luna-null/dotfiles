#!/bin/bash
# vncgetspotify.sh
# Gets spotify for ssh

export DISPLAY=:0

id=$(wmctrl -lx | awk '/spotify.exe.Wine/ {print $1}')
[[ -z $id ]] && id=$(wmctrl -lx | awk '/spotify.Spotify/ {print $1}')

x11vnc -sid $id -display :0 -auth .Xauthority
