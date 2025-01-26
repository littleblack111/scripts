#!/bin/bash

$@ || notify-send "Command failed: $*"
