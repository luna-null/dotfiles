#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

<<<<<<< HEAD
export XCURSOR_SIZE=96

=======
>>>>>>> 67261ada362766d19b2095a9f6a492ddc45110bb
# merge in defaults and keymaps

if [ -f $sysresources ]; then

<<<<<<< HEAD
=======






>>>>>>> 67261ada362766d19b2095a9f6a492ddc45110bb
    xrdb -merge $sysresources

fi

<<<<<<< HEAD


=======
>>>>>>> 67261ada362766d19b2095a9f6a492ddc45110bb
if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

<<<<<<< HEAD


if [ -f "$userresources" ]; then

=======
if [ -f "$userresources" ]; then







>>>>>>> 67261ada362766d19b2095a9f6a492ddc45110bb
    xrdb -merge "$userresources"

fi

<<<<<<< HEAD


=======
>>>>>>> 67261ada362766d19b2095a9f6a492ddc45110bb
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

<<<<<<< HEAD


=======
>>>>>>> 67261ada362766d19b2095a9f6a492ddc45110bb
# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

<<<<<<< HEAD


=======
>>>>>>> 67261ada362766d19b2095a9f6a492ddc45110bb
twm &
xclock -geometry 50x50-1+1 &
xterm -geometry 80x50+494+51 &
xterm -geometry 80x20+494-0 &
exec xterm -geometry 80x66+0+0 -name login
<<<<<<< HEAD
nm-applet &

exec dbus-run-session bspwm
=======
>>>>>>> 67261ada362766d19b2095a9f6a492ddc45110bb
