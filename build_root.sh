#!/bin/bash
set -e

echo "Building root"

WORK_DIR=$1
SRC_DIR=${WORK_DIR}/src
BUILD_DIR=${WORK_DIR}/build
INSTALL_DIR=$WORK_DIR/install

mkdir -p $WORK_DIR
cd $WORK_DIR

curl -SL https://root.cern/download/root_v${ROOT_VERSION}.source.tar.gz | tar -xzC . 
mv root-* ${SRC_DIR}
cmake -S ${SRC_DIR} -B ${BUILD_DIR} \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_CXX_STANDARD=17  \
	-DCMAKE_PREFIX_PATH=${DEPENDENCY_DIR} \
	-DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
	-Dx11=ON  \
	-Dfftw3=ON  \
	-Dgdml=ON  \
	-Dminuit2=ON  \
	-Dopengl=ON  \
	-Droofit=ON  \
	-Dxml=ON
cmake --build ${BUILD_DIR} -- -j2
cmake --install ${BUILD_DIR}
tar czf ../root.tar.gz -C ${INSTALL_DIR} .
