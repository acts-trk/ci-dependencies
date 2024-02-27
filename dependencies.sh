#!/bin/bash
set -e

# @TODO Only on macos

function run() { 
  set -x
  "$@" 
  { set +x;   } 2> /dev/null
}


run brew update
run brew install ccache xerces-c eigen boost 
run brew reinstall cmake

run brew list r
if [ $? -eq 0 ]; then
  run brew unlink r
fi
