#!/bin/bash

#Use this script to add dendro install as an upstream repository (for easy pulling into other repositories that track this one!)

# track upstream remote repository
git remote add upstream https://github.com/feup-infolab/dendro-install.git

#block pushing to the tracked repository
git config remote.upstream.pushurl "NEVER GONNA GIVE YOU UP"
