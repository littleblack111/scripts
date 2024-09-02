#!/bin/bash

usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
tempreture=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

echo "{\"text\": \"$usage\", \"alt\": \"$tempreture\"}"
