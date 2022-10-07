#!/bin/bash
set -e

echo "Building tbb"

WORK_DIR=$1

mkdir -p $WORK_DIR
cd $WORK_DIR

curl -SL https://github.com/oneapi-src/oneTBB/releases/download/v${TBB_VERSION}/oneapi-tbb-${TBB_VERSION}-mac.tgz | tar -xzC .
tar czf tbb.tar.gz -C oneapi-tbb-* .
