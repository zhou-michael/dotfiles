#!/usr/bin/env sh

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8")
SPACE_CLICK_SCRIPT="yabai -m space --focus \$SID 2>/dev/null"

#sid=0
#for i in "${!SPACE_ICONS[@]}"
#do
#  sid=$(($i+1))
#  sketchybar --add space      space.$sid left                               \
#             --set space.$sid associated_space=$sid                         \
#                              icon=${SPACE_ICONS[i]}                        \
#                              icon.padding_left=14                          \
#                              icon.padding_right=16                         \
#                              label.padding_right=33                        \
#                              icon.highlight_color=$RED                     \
#                              background.padding_left=-8                    \
#                              background.padding_right=-8                   \
#                              background.color=$BACKGROUND_1                \
#                              background.drawing=on                         \
#                              label.font="sketchybar-app-font:Regular:13.0" \
#                              label.background.height=24                    \
#                              label.background.drawing=on                   \
#                              label.background.color=$BACKGROUND_2          \
#                              label.background.corner_radius=9              \
#                              label.drawing=off                             \
#                              script="$PLUGIN_DIR/space.sh"                 \
#                              click_script="$SPACE_CLICK_SCRIPT"
#done

sid=0
for i in "${!SPACE_ICONS[@]}"
do
  sid=$(($i+1))
  sketchybar --add space      space.$sid left                               \
             --set space.$sid associated_space=$sid                         \
                              icon=${SPACE_ICONS[i]}                        \
                              icon.padding_left=7                           \
                              icon.padding_right=7                          \
                              icon.highlight_color=$RED                     \
                              icon.font="$FONT:Bold:12.0"                   \
                              icon.y_offset=1                               \
                              background.border_width=2                     \
                              background.padding_left=2                     \
                              background.padding_right=2                    \
                              background.color=$SPACES_COLOR                \
                              background.border_color=$SPACES_BORDER_COLOR  \
                              background.drawing=on                         \
                              background.corner_radius=6                    \
                              label.font="sketchybar-app-font:Regular:11.0" \
                              label.background.height=24                    \
                              label.background.drawing=on                   \
                              label.background.corner_radius=6              \
                              label.padding_left=0                          \
                              label.padding_right=0                        \
                              label.drawing=off                             \
                              click_script="$SPACE_CLICK_SCRIPT"            \
                              script="$PLUGIN_DIR/space.sh"                 
done

sketchybar   --add item       separator left                          \
             --set separator  icon=                                  \
                              icon.font="Hack Nerd Font:Regular:16.0" \
                              background.padding_left=7             \
                              background.padding_right=2             \
                              label.drawing=off                       \
                              associated_display=active               \
                              click_script='yabai -m space --create && sketchybar --trigger space_change' \
                              icon.color=$WHITE
