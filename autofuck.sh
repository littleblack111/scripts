#!/usr/bin/env bash
$@
if [ $? -eq 0 ]; then
  echo "git status exited successfully"
else
  echo "git status exited with error code"
fi
