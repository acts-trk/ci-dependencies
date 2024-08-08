#!/bin/bash
set -e

# @TODO Only on macos

function run() { 
  set -x
  "$@" 
  { set +x;   } 2> /dev/null
}


run brew update
run brew install ccache openssl@3 zlib zstd ncurses expat xerces-c freetype xz lz4 libx11 libxml2 libxpm libxft sqlite
run brew reinstall cmake

brew unlink r || true
