#!/bin/bash

volume_slider=(
  script="$PLUGIN_DIR/volume.sh"
  updates=on
  label.drawing=off
  icon.drawing=off
  slider.highlight_color=$BLUE
  slider.background.height=5
  slider.background.corner_radius=3
  slider.background.color=$BACKGROUND_2
  slider.knob=􀀁
  slider.knob.drawing=off
)

#volume_icon=(
#  click_script="$PLUGIN_DIR/volume_click.sh"
#  padding_left=10
#  icon=$VOLUME_100
#  icon.width=0
#  icon.align=left
#  icon.color=$GREY
#  icon.font="$FONT:Regular:14.0"
#  label.width=25
#  label.align=left
#  label.font="$FONT:Regular:14.0"
#)

volume_icon=(
  click_script="$PLUGIN_DIR/volume_click.sh"
  icon.drawing=off
  label.drawing=off
  alias.color=$WHITE
  width=35
  align=right
  label.font="$FONT:Regular:14.0"
)

status_bracket=(
  background.color=$SPACES_COLOR
  background.border_color=$SPACES_BORDER_COLOR
  background.border_width=2
)

sketchybar --add slider volume right            \
           --set volume "${volume_slider[@]}"   \
           --subscribe volume volume_change     \
                              mouse.clicked     \
                              mouse.entered     \
                              mouse.exited      \
                                                \
           --add alias "Control Center,Sound" right \
           --rename "Control Center,Sound" volume_icon \
           --set volume_icon "${volume_icon[@]}"
#           --add item volume_icon right         \

sketchybar --add bracket status battery volume volume_icon github.bell brew \
           --set status "${status_bracket[@]}"
