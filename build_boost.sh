#!/bin/bash
set -e

echo "Building boost"

WORK_DIR=$1
SRC_DIR=${WORK_DIR}/src
BUILD_DIR=${WORK_DIR}/build
INSTALL_DIR=$WORK_DIR/install

mkdir -p $WORK_DIR
cd $WORK_DIR

# curl -SL https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION//./_}.tar.gz | tar -xzC .
# mv boost_* ${SRC_DIR}
cd ${SRC_DIR}
./bootstrap.sh --prefix=${INSTALL_DIR}
./b2 install --build-dir=${BUILD_DIR}
tar czf ../boost.tar.gz -C ${INSTALL_DIR} .
