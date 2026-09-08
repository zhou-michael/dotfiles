#!/usr/bin/env sh

source "$HOME/.config/sketchybar/colors.sh"

COUNT=$(brew outdated | wc -l | tr -d ' ')

COLOR=$RED

case "$COUNT" in
  [3-5][0-9]) COLOR=$ORANGE
  ;;
  [1-2][0-9]) COLOR=$YELLOW
  ;;
  [1-9]) COLOR=$WHITE
  ;;
  0) COLOR=$WHITE
  ;;
esac

if [ "$COUNT" -eq "0" ]; then
    COUNT="";
fi

sketchybar --set $NAME label=$COUNT icon.color=$COLOR
