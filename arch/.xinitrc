#!/bin/bash

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

session=${2:-startlxde}

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

case $session in
  startlxde      ) exec /usr/bin/startlxde;;
  i3             ) exec /usr/bin/i3;;
  xterm          ) exec /usr/bin/urxvt;;
  kali           ) exec /usr/bin/urxvt -e ~/kali desktop;;
  kalixfce       ) exec /usr/bin/urxvt -e ~/kali desktop xfce;;
  *) $1;;
esac


