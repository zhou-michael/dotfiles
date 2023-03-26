#!/usr/bin/env sh

source ~/.config/sketchybar/colors.sh

BORDER=$BACKGROUND_2
if [ "$SELECTED" = "true" ]; then
    BORDER=$GREY
fi

sketchybar --animate tanh 20 --set $NAME background.color=$BACKGROUND_1 background.border_color=$BORDER icon.color=$WHITE label.color=$WHITE
