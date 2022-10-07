#!/bin/bash
set -e

echo "Building xercesc"

WORK_DIR=$1
SRC_DIR=${WORK_DIR}/src
BUILD_DIR=${WORK_DIR}/build
INSTALL_DIR=$WORK_DIR/install

mkdir -p $WORK_DIR
cd $WORK_DIR

curl -SL https://github.com/apache/xerces-c/archive/v${XERCESC_VERSION}.tar.gz | tar -xzC . 
mv xerces-c-* ${SRC_DIR}
cmake -S ${SRC_DIR} -B ${BUILD_DIR} \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
cmake --build ${BUILD_DIR} -- -j2
cmake --install ${BUILD_DIR}
tar czf ../xercesc.tar.gz -C ${INSTALL_DIR} .
