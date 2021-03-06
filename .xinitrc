#!/bin/bash

command_exists () {
  # https://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then
  # https://unix.stackexchange.com/questions/86012/what-is-the-purpose-of-the-hash-command
  command -v "$1" > /dev/null 2>&1
  return $?
}

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
userhostmodmap=$HOME/.Xmodmap-$(hostname |sha256sum |head -c 16)
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# xstart ~/.xinitrc session...
session=${2:-i3}

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

if [ -f "$userhostmodmap" ]; then
  xmodmap "$userhostmodmap"
else
  if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
  fi
fi

[ -x "$HOME/.xinitrc-local" ] && "$HOME/.xinitrc-local"

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
    # shellcheck source=/dev/null
    [ -x "$f" ] && source "$f"
   done
   unset f
fi

dbus=""
command_exists dbus-launch && dbus="dbus-launch --exit-with-session "
case $session in
  startlxde      ) exec "$dbus" startlxde;;
  i3             ) exec "$dbus" i3;;
  i3debug        ) exec "$dbus" i3 --shmlog-size=26214400;;
  xterm          ) exec "$dbus" /usr/bin/urxvt;;
  kali           ) exec "$dbus" /usr/bin/urxvt -e ~/kali desktop;;
  kalixfce       ) exec "$dbus" /usr/bin/urxvt -e ~/kali desktop xfce;;
  *) $1;;
esac


