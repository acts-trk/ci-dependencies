#!/bin/bash
set -e

export XERCESC_VERSION=3.2.2
export ROOT_VERSION=6.26.00
export GEANT4_VERSION=11.0.0
export DD4HEP_VERSION=01-21
export BOOST_VERSION=1.78.0
export TBB_VERSION=2021.5.0
export HEPMC_VERSION=3.2.1
export PYTHIA8_VERSION=307
export PODIO_VERSION=v00-14-01
export EDM4HEP_VERSION=v00-04-01

export BUILD_DIR=$PWD/build
export DEPENDENCY_DIR=$HOME/hep

if [ ! -d "$PWD/boost" ]; then
	time ./build_boost.sh $PWD/boost
fi

if [ ! -d "$PWD/tbb" ]; then
	time ./build_tbb.sh $PWD/tbb
fi

if [ ! -d "$PWD/xercesc" ]; then
	time ./build_xercesc.sh $PWD/xercesc
fi

if [ ! -d "$PWD/root" ]; then
	time ./build_root.sh $PWD/xercesc
fi
