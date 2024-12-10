#!/bin/bash
set -u

columns=$(stty size | cut -d ' ' -f2)
function fill_line() {
    sep=${1:-=}
    printf "=%.0s" $(seq 1 "$columns") | tr "=" "$sep"
    echo ""
}

function print_center() {
    text="$1"
    printf "%*s\n" $(((${#text}+$columns)/2)) "$text"
}

function heading() {
    fill_line
    print_center "$1"
    fill_line
}


cat << EOF
    _      ____  _____  ____
   / \    / ___||_   _|/ ___|
  / _ \  | |      | |  \___ \
 / ___ \ | |___   | |   ___) |
/_/   \_\ \____|  |_|  |____/
EOF
fill_line

echo "This script will build the ACTS framework and its dependencies."

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source ${script_dir}/detect_os.sh
echo "OS: ${os_name}"

if [ $(whoami) == "root" ]; then
  SUDO=""
else
  SUDO="sudo "
fi

function printDependencyOneliner {


  heading "Missing dependencies"

  echo "If you're having problems with missing dependencies, try this one-liner:"
  if [ $os == "ubuntu" ]; then
    echo "> ${SUDO}apt-get install -y cmake build-essential libssl-dev zlib1g-dev libncurses5-dev libexpat-dev libxerces-c-dev rsync libfreetype-dev liblzma-dev liblz4-dev libx11-dev libxpm-dev libxft-dev libxext-dev libglu1-mesa-dev libxml2-dev git libzstd-dev"
  elif [ $os == "almalinux" ]; then
    echo "> ${SUDO}dnf group install -y \"Development Tools\" && ${SUDO}dnf install -y epel-release && ${SUDO}dnf install -y cmake  openssl-devel zlib-devel ncurses-devel expat-devel xerces-c-devel rsync freetype-devel xz-devel lz4-devel libX11-devel libXpm-devel libXft-devel libXext-devel mesa-libGLU-devel libxml2-devel git libzstd-devel"
  else
    echo "> Install homebrew from https://brew.sh"
    echo "> xcode-select --install"
    echo "> brew install cmake openssl@3 zlib zstd ncurses expat xerces-c rsync freetype xz lz4 libx11 libxml2 git jq"
  fi

  fill_line

}

trap printDependencyOneliner ERR

function interruptHandler {
  kill -TERM -$$
}

trap interruptHandler INT


build_dir=${1:-$PWD/build}
install_dir=${2:-$PWD/install}

echo "Build directory: ${build_dir}"
echo "Install directory: ${install_dir}"

fill_line "-"

cmake_loc=$(command -v cmake)

if [ -z "$cmake_loc" ]; then
  echo "CMake not found in PATH, install like:"
  if [ $os == "ubuntu" ]; then
    echo "> ${SUDO}apt-get install -y cmake"
  elif [ $os == "almalinux" ]; then
    echo "> ${SUDO}dnf install -y cmake"
  elif [ $os == "macos" ]; then
    echo "> brew install cmake"
  fi
  echo "Exiting."
  exit 1
fi

if [ $(uname) == "Linux" ]; then
  cxx_loc=$(which g++)
  if [ -z "$cxx_loc" ]; then
    echo "g++ not found in PATH, install like:"
    if [ $os == "ubuntu" ]; then
      echo "> ${SUDO}apt-get install -y build-essential"
    elif [ $os == "almalinux" ]; then
      echo "> ${SUDO}dnf group install -y \"Development Tools\""
    fi
    echo "Exiting."
    exit 1
  fi
  PROC=$(nproc)
else
  clang_loc=$(command -v clang++)
  if [ -z "$clang_loc" ]; then
    echo "clang++ not found in PATH, install like:"
    echo "> xcode-select --install"
    echo "Exiting."
    exit 1
  fi

  brew_loc=$(command -v brew)
  if [ -z "$brew_loc" ]; then
    echo "brew not found in PATH, you probably want it for later"
    echo "Install from: https://brew.sh"
    echo "Exiting."
    exit 1
  fi
  PROC=$(sysctl -n hw.physicalcpu)
fi

build_acts=ON
if [ ! -d "${script_dir}/acts" ]; then
  echo "No ACTS directory found, do you want me to clone the upstream repository?"
  # ask user for input
  read -p "Clone ACTS repository? [y/n] " -n 1 -r
  echo ""
  echo "Ok!"
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "SSH or HTTPS? [s/h] " -n 1 -r
    if [[ $REPLY =~ ^[Ss]$ ]]; then
      url="git@github.com:acts-project/acts.git"
    else
      url=https://github.com/acts-project/acts.git
    fi
    echo ""
    echo "Cloning ACTS from ${url} to ${script_dir}/acts"
    git clone ${url} ${script_dir}/acts
  else
    echo "Not cloning ACTS, turning off the ACTS build"
    build_acts=OFF
  fi
fi

set -e

cmake -S ${script_dir} -B ${build_dir} \
  -DBUILD_ACTS=${build_acts} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_COMPILER=g++ \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_CXX_STANDARD=20 \
  -DCMAKE_INSTALL_PREFIX=${install_dir} \
  -DCMAKE_BUILD_PARALLEL_LEVEL=$PROC

cmake --build ${build_dir} --target python > ${build_dir}/python.log 2>&1 &
python_pid=$!

cmake --build ${build_dir} --target boost eigen tbb geant4 hepmc3 nlohmann_json

echo "Waiting for python to finish:"
tail -f ${build_dir}/python.log &
tail_pid=$!
wait $python_pid
echo "Python is ready"
kill $tail_pid
wait $tail_pid 2> /dev/null || true

cmake --build ${build_dir} --target pythia8 > ${build_dir}/pythia8.log 2>&1 &
pythia8_pid=$!

cmake --build ${build_dir} --target root podio edm4hep dd4hep

echo "Waiting for pythia8 to finish:"
tail -f ${build_dir}/pythia8.log &
tail_pid=$!
wait $pythia8_pid
echo "Pythia8 is ready"
kill $tail_pid
wait $tail_pid 2> /dev/null || true


echo "Rerun combined build to ensure all dependencies are built"
cmake --build ${build_dir}

heading "Build complete"
