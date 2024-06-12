#!/bin/bash
set -e

# @TODO Only on macos

function run() { 
  set -x
  "$@" 
  { set +x;   } 2> /dev/null
}


run brew update
run brew install ccache xerces-c
run brew reinstall cmake

brew unlink r || true