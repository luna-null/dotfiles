#!/usr/bin/env bash

# filesearch.sh

# wofi returns the selected item or what is entered

# Get the filepath from the user
FILEPATH=$(wofi -d)

# you can pipe the list for wofi to display and search

# Present the user with a list of files in FILEPATH and let them select one
# Store their selection in FILE
FILE=$(ls $FILEPATH | wofi -d)

# Do whatever you want with FILE
echo $FILE

# Alternatively do this all as a one liner:
# echo `wofi -d | xargs -r ls | wofi -d`
