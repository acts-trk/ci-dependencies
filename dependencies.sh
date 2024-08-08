#!/bin/bash
set -e

function run() { 
  set -x
  "$@" 
  { set +x;   } 2> /dev/null
}

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source ${script_dir}/detect_os.sh
echo "OS: ${os_name}"

if [ $os == "ubuntu" ]; then
  echo "Installing dependencies for Ubuntu"
elif [ $os == "macos" ]; then
  echo "Installing dependencies for macOS"
  run brew update
  run brew install ccache openssl@3 zlib zstd ncurses expat xerces-c freetype xz lz4 libx11 libxml2 libxpm libxft
  run brew reinstall cmake

  brew unlink r || true
else
  echo "Only Ubuntu and macOS are supported. Exiting."
  exit 1
fi
