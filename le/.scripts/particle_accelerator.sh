#!/bin/bash

case $# in
  1)  time=1;
      acc=.1;
      end=100;;
  2)  time=$2;
      acc=.1;
      end=100;;
  3)  time=$2;
      acc=$3;
      end=100;;
  4)  time=$2;
      acc=$3;
      end=$4;;
  esac
  cpu=0  
  iter=0
  while [ "$iter" -le "$end" ] || [ "$cpu" -gt 80 ]; do
    eval $1 & sleep "$time";
    let "time=time/(1+acc*time)" "iter=iter+1"
    if [ `expr $iter % 5` -eq 15 ]; then
      cpu=$(top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,' |awk '{print ($6)}' &)
    fi
  done
  vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print ($5)}')
  pactl set-sink-volume @DEFAULT_SINK@ 100%
  explosion & $1 & $1 & $1 & $1 & $1 & $1 & $1 & $1 & $1 & $1 &
  while pgrep mpv > /dev/null; do
    pactl set-sink-volume @DEFAULT_SINK@ 100%
  done
    
  pactl set-sink-volume @DEFAULT_SINK@ "$vol"


