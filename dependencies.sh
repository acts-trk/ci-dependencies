#!/bin/bash
set -e

# @TODO Only on macos


brew install ccache xerces-c eigen boost 
brew reinstall cmake
brew unlink r
