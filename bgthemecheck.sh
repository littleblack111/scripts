#!/bin/bash

IMAGE=$(cat "$HOME"/.cache/current.bg)
MAGMEAN=$(magick identify -format %[mean] "$IMAGE")
MAXMEAN=30000

if [ "${MAGMEAN%.*}" -eq ${MAXMEAN%.*} ] && [ "${MAGMEAN#*.}" \> ${MAXMEAN#*.} ] || [ "${MAGMEAN%.*}" -gt ${MAXMEAN%.*} ]; then
    printf "light\n"
    exit 0
else
    printf "dark\n"
    exit 0
fi
