#!/bin/bash
set -e

# @TODO Only on macos


brew update
brew install ccache xerces-c eigen boost 
brew reinstall cmake

if [ $(brew list r) -eq 1 ]; then
  brew unlink r
fi
