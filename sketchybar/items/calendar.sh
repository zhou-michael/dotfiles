#!/usr/bin/env sh

sketchybar --add item     calendar right                    \
           --set calendar icon=cal                          \
                          icon.font="$FONT:Black:12.0"      \
                          icon.padding_right=0              \
                          label.width=50                    \
                          label.align=right                 \
                          background.padding_left=0         \
                          padding_left=15                   \
                          padding_right=20                  \
                          update_freq=5                     \
                          script="$PLUGIN_DIR/calendar.sh"  \
                          click_script="$PLUGIN_DIR/zen.sh" \
           --subscribe calendar system_woke
