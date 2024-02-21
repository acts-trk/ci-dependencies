#!/bin/bash
set -e

# @TODO Only on macos


brew update
brew install ccache xerces-c eigen boost 
brew reinstall cmake

brew list -r
if [ $? -eq 1 ]; then
  brew unlink r
fi
