#!/bin/bash
# vncget.sh
# gets spotify window for ssh

if [[ $1 == all ]];then
  ssh -f -t -L 5900:localhost:5900 user@host "x11vnc -q -display :0 -auth .Xauthority"
else
  ssh -f -t -L 5900:localhost:5900 user@host ".bin/vncgetspotify.sh"
fi
 
for i in {1..4}; do
  sleep 2
  if vncviewer localhost:0; then break; fi
done
