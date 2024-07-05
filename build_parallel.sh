#!/bin/bash
set -u

cat << EOF
    _      ____  _____  ____  
   / \    / ___||_   _|/ ___| 
  / _ \  | |      | |  \___ \ 
 / ___ \ | |___   | |   ___) |
/_/   \_\ \____|  |_|  |____/ 
EOF

echo "This script will build the ACTS framework and its dependencies."

if [ $(uname) == "Linux" ]; then
  os_name=$(cat /etc/os-release | grep -e "^PRETTY_NAME=" | sed 's/PRETTY_NAME="\(.*\)"/\1/g')
  if [[ $os_name == *"Ubuntu"* ]]; then
    os="ubuntu"
  elif [[ $os_name == *"AlmaLinux"* ]]; then
    os="almalinux"
  fi
elif [ $(uname) == "Darwin" ]; then
  os_name="$(sw_vers -productName) $(sw_vers -productVersion)"
  os="macos"
else
  echo "Only Ubuntu, AlmaLinux and macOS are supported. Exiting."
  exit 1
fi
echo "OS: ${os_name}"

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

build_dir=${1:-$PWD/build}
install_dir=${2:-$PWD/install}

build_dir=$(realpath $build_dir)
install_dir=$(realpath $install_dir)

echo "Build directory: ${build_dir}"
echo "Install directory: ${install_dir}"


cmake_loc=$(command -v cmake)

if [ -z "$cmake_loc" ]; then
  echo "CMake not found in PATH, install like:"
  if [ $os == "ubuntu" ]; then
    echo "> sudo apt-get install -y cmake"
  elif [ $os == "almalinux" ]; then
    echo "> sudo dnf install -y cmake"
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
      echo "> sudo apt-get install -y build-essential"
    elif [ $os == "almalinux" ]; then
      echo "> sudo dnf group install -y \"Development Tools\""
    fi
    echo "Exiting."
    exit 1
  fi
else
  clang_loc=$(which clang++)
  if [ -z "$clang_loc" ]; then
    echo "clang++ not found in PATH, install like:"
    echo "> xcode-select --install"
    echo "Exiting."
    exit 1
  fi
fi

set -e

cmake -S ${script_dir} -B ${build_dir} \
  -DBUILD_ACTS=ON \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_COMPILER=g++ \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_CXX_STANDARD=20 \
  -DCMAKE_INSTALL_PREFIX=${install_dir} \
  -DCMAKE_BUILD_PARALLEL_LEVEL=$(nproc)

cmake --build ${build_dir}
exit 

cmake --build ${build_dir} --target python > ${build_dir}/python.log 2>&1 &
python_pid=$!

cmake --build ${build_dir} --target boost eigen tbb geant4 hepmc3 nlohmann_json 

echo "Waiting for python to finish:"
tail -f ${build_dir}/python.log &
tail_pid=$!
wait $python_pid
kill $tail_pid
wait $tail_pid

cmake --build ${build_dir} --target pythia8 > ${build_dir}/pythia8.log 2>&1 &
pythia8_pid=$!

cmake --build ${build_dir} --target root podio edm4hep dd4hep

echo "Waiting for pythia8 to finish:"
tail -f ${build_dir}/pythia8.log &
tail_pid=$!
wait $pythia8_pid
kill $tail_pid
wait $tail_pid

echo "Rerun combined build to ensure all dependencies are built"
cmake --build ${build_dir}
