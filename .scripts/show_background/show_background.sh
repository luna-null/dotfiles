#!/bin/bash

# Script to show background in sway.

PROG=$( basename "$0" )

NO_RETURN=
export POSIXLY_CORRECT="set"

for i in "$@"; do
    case "$i" in
        -h|--help)
            echo "Runs until a certain button combination is released."
            ;;
        -n|--n*)
            NO_RETURN="set"
            shift
            ;;
        --)
            shift
            break
            ;;
    esac
done


# takes the contents of swaymsg -t get_workspaces, checkts if the "type" var is null, 
# then selects the one that is focused and puts it in $focused_workspace
focused_workspace=$(swaymsg -t get_workspaces | jq -r '..| select(.type?) | select(.focused==true) | .name')

# searches tree for $focused_workspace, selects containers within it


CON_ID_STR=$(swaymsg -t get_tree | jq -r '..| select(.type?) | select(.name==$ARGS.positional[0])
' --args $focused_workspace | jq -r '..| select (.type?) | select(.type=="con") | .id')

# turns con_str into list via string manipulation 
for i in ${CON_ID_STR// / }; do
    CON_ID_LIST+=($i); done

# same thing for types of containers... probably a better way to do it, but this works for now hopefully 
CON_TYPE_STR=$(swaymsg -t get_tree | jq -r '..| select(.type?) | select(.name==$ARGS.positional[0])
' --args $focused_workspace | jq -r '..| select (.type?) | select(.type=="con") | .type')

for i in ${CON_TYPE_STR// / }; do
    CON_TYPE_LIST+=($i); done

# same thing for types of containers 
CON_BORDER_STR=$(swaymsg -t get_tree | jq -r '..| select(.type?) | select(.name==$ARGS.positional[0])
' --args $focused_workspace | jq -r '..| select (.type?) | select(.type=="con") | .border')

for i in ${CON_BORDER_STR// / }; do
    CON_BORDER_LIST+=($i); done


# creates list of whether containers are floating from container list
for i in $(seq 0 "$((${#CON_ID_LIST[@]} - 1))"); do

    FLOATING="enable"

    [[ "${CON_TYPE_LIST[i]}" == "floating_con" ]] || FLOATING="disable"
    FLOATING_LIST+=($FLOATING)

    swaymsg "[con_id=${CON_ID_LIST[i]}] focus; move window to scratchpad";
done

echo export WAIT_APPS=1 > cache
. exec
while [[ "$WAIT_APPS" -eq 1 ]]; do
    . cache
    sleep 1;
done

for j in $(seq 0 "$((${#CON_ID_LIST[@]} - 1))"); do 

    swaymsg "[con_id=${CON_ID_LIST[j]}] focus; floating ${FLOATING[j]}; border ${CON_BORDER_LIST[j]}";

done

exit

# Local Variables:
# mode: shell-script
# time-stamp-pattern: "4/TIME_STAMP=\"%:y%02m%02d.%02H%02M%02S\""
# eval: (add-hook 'before-save-hook 'time-stamp)
# End
