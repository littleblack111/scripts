#!/bin/bash

# YARN
yarn cache clean || sudo yarn cache clean

# PIP
pip cache purge || sudo pip cache purge

# NPM
npm cache clean --force || sudo npm cache clean --force

# pacman
sudo pacman -Scc --noconfirm
