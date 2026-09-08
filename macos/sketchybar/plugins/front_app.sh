#!/usr/bin/env sh

if [[ ${#INFO} -gt 25 ]]
then
    sketchybar --set front_app label="${INFO:0:22}..."
else
    sketchybar --set front_app label=$INFO
fi

