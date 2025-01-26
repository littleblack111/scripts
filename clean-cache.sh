#!/bin/bash

# get perm
sudo -v

# YARN
yarn cache clean || sudo yarn cache clean

# PIP
pip cache purge || sudo pip cache purge

# NPM
npm cache clean --force || sudo npm cache clean --force

# pacman
sudo pacman -Scc --noconfirm

# trash
trash-empty 30 -f
sudo trash-empty 30 -f
sudo -E trash-empty 30 -f

# AUR archbuilds
sudo rm -rf /var/lib/archbuild

# debtap
sudo rm -rf /var/cache/debtap

# vscode cpptools
rm -rf $XDG_CACHE_HOME/vscode-cpptools
