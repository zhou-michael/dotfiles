#!/usr/bin/env sh

source ~/.config/sketchybar/colors.sh

BORDER=$SPACES_BORDER_COLOR
if [ "$SELECTED" = "true" ]; then
    BORDER=0xbbedc8cc
fi

sketchybar --animate tanh 20 --set $NAME background.border_color=$BORDER icon.color=$WHITE label.color=$WHITE
