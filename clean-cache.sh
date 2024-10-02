#!/bin/bash

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
