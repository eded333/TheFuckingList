#!/bin/bash

default_branch=`basename $(git symbolic-ref --short refs/remotes/origin/HEAD)`

sudo git checkout --orphan tmp
sudo git add -A								# Add all files and commit them
sudo git commit
sudo git branch -D $default_branch			# Deletes the default branch
sudo git branch -m $default_branch			# Rename the current branch to default
sudo git push -f origin $default_branch		# Force push default branch to github
sudo git gc --aggressive --prune=all		# remove the old files