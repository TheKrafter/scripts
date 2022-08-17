#!/usr/bin/env bash
# Modified by Krafter
# From the Original at: https://www.reddit.com/r/unixporn/comments/3358vu/i3lock_unixpornworthy_lock_screen/
# Description: Heavily Pixelizes and locks the screen via imagemagick and i3lock.
# Also, checks if media is playing, pauses media, and unpauses it.
scrot /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png
[[ -f $1 ]] && convert /tmp/screen.png $1 -gravity center -composite -matte /tmp/screen.png
#dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop
if [ $(playerctl status) == "Playing" ];
then
	playing=True
fi
playerctl pause
i3lock -i /tmp/screen.png -n -f
if [ $playing == "True" ]
then
	playerctl play
fi
rm /tmp/screen.png

