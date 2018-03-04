#!/bin/sh


SYS_RESOURCES=/etc/X11/xinit/Xresources
SYS_MODMAP=/etc/X11/xinit/Xmodmap

if [ -f "$SYS_RESOURCES" ]
then
	xrdb -merge "-I`dirname "$SYS_RESOURCES"`" "$SYS_RESOURCES"
fi

if [ -f "$SYS_MODMAP" ]
then
	xmodmap "$SYS_MODMAP"
fi


USER_RESOURCES="$HOME/.Xresources"
USER_MODMAP="$HOME/.Xmodmap"

if [ -f "$USER_RESOURCES" ]
then
	xrdb -merge "-I`dirname "$USER_RESOURCES"`" "$USER_RESOURCES"
fi

if [ -f "$USER_MODMAP" ]
then
	xmodmap "$USER_MODMAP"
fi


SYSTEM_SPECIFIC_RESOURCES="$HOME/.config/X/Xresources"
SYSTEM_SPECIFIC_MODMAP="$HOME/.config/X/Xmodmap"
SYSTEM_SPECIFIC_INIT="$HOME/.config/X/xinitrc"

if [ -f "$SYSTEM_SPECIFIC_RESOURCES" ]
then
	xrdb -merge "-I`dirname "$SYSTEM_SPECIFIC_RESOURCES"`" "$SYSTEM_SPECIFIC_RESOURCES"
fi

if [ -f "$SYSTEM_SPECIFIC_MODMAP" ]
then
	xmodmap "$SYSTEM_SPECIFIC_MODMAP"
fi

if [ -f "$SYSTEM_SPECIFIC_INIT" ]
then
	. "$SYSTEM_SPECIFIC_INIT"
fi


if hash xbindkeys 2>/dev/null
then
	xbindkeys
fi
