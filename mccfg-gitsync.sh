#!/usr/bin/env bash
# coding: UTF-8
# end-of-line: LF
# indentation: 4 spaces
alias fizz="echo 'Fizzdev is a catboy.'"
####
## ./mccfg-gitsync.sh
# Copyright (c) 2022 Krafter, Published under the MIT License. https://mit-license.org/
####
# This script copies mc server configs and pushes them to a git repo, and pulls them from one and copies them to the correct locations.
# It is intended to be executed from within the mc server directory.
# Fun Fact: it was made solely with open source software.
#
# Usage: ./mccfg-gitsync.sh [action]
# Actions:
#   push        Copies server cfgs to a seperate folder and pushes to a configured git repo
#   pull        Pulls from git repo and copies server cfgs to correct locations
####
# DEPENDENCIES
# - bash
# - git
# - 
# - binutils
####
##  VARIABLES
# TO EDIT:
MCCFG_FILES="./files.txt"
# ^^^ Path to file containing list of files to sync. one file per line, paths realative to current working directory upon execution.
# IMPORTANT: this uses rsync, so NO TRAILING SPACES. The script auto-removes the problematic newline.
MCCFG_GIT_DIR="./.cache/gitsync" # Directory to cache files for syncing with git. The script will recursively delete this directory during cleanup.
MCCFG_GIT_URI="https://TheKrafter:ghp_personalacesstoken@github.com/TheKrafter/mcservercfgs-testing.git" # git uri with auth
# Example: "https://username:password@git.example.com/user/repo.git"
#   NOTE: on github, use personal access token instead of password.
MCCFG_DATE_FLAGS="" # Flags to run with the date command, to specify output. Used for the commit name. Without this the bare output of date will be used.
MCCFG_COMMIT_MSG="Synced config files from server on" # Commit message. Followed by the current date.
##
# DON'T TOUCH:
WORKINGDIR=$(pwd)
ACTION=$1
MCCFG_GIT_REPONAME=$(basename --suffix=.git $MCCFG_GIT_URI)
####
#### SCRIPT:
####
# HELP MENU
if [ "$ACTION" = "--help" ]; 
then
    echo "Usage: ./mccfg-gitsync.sh [action]"
    echo "Note: You will have to edit this script to set certain variables."
    echo "Actions:"
    echo "  push        Copies server cfgs to a seperate folder and pushes to a configured git repo"
    echo "  pull        Pulls from git repo and copies server cfgs to correct locations"
fi
# Regardless of action:
mkdir -p $MCCFG_GIT_DIR
sed -z 's/\n$//' $MCCFG_FILES
echo "./mccfg-gitsync.sh"
echo "Copyright (c) 2022 Krafter, Published under the MIT License"
echo "Cloning from git repo $MCCFG_GIT_REPONAME..."
git -C $MCCFG_GIT_DIR clone "$MCCFG_GIT_URI"

# ACTION: pull
if [ "$ACTION" = "pull" ];
then
    echo "Copying config files to correct locations..." #--exclude={$MCCFG_GIT_IGNORE}
    #rsync -I $MCCFG_GIT_DIR/$MCCFG_GIT_REPONAME/* $MCCFG_SERVERDIR/*
    cp -r $MCCFG_GIT_DIR/$MCCFG_GIT_REPONAME/* $WORKINGDIR/
    echo "Done."
fi

# ACTION: push
if [ "$ACTION" = "push" ];
then
    echo "Sending config files to git repo dir..."
    rsync -I --checksum --files-from=$MCCFG_FILES $WORKINGDIR/ $MCCFG_GIT_DIR/$MCCFG_GIT_REPONAME/
    echo "Done."
    git -C $MCCFG_GIT_DIR/$MCCFG_GIT_REPONAME/ add -A
    git -C $MCCFG_GIT_DIR/$MCCFG_GIT_REPONAME/ commit -m "$MCCFG_COMMIT_MSG $(date $MCCFG_DATE_FLAGS)"
    git -C $MCCFG_GIT_DIR/$MCCFG_GIT_REPONAME/ push
fi

# Clean up
echo "Cleaning up..."
rm -r --interactive=never $MCCFG_GIT_DIR/
echo "Done."
echo
