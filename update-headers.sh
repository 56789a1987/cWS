#!/bin/bash

set -eu
mkdir -p targets

if [ -e targets/headers ]; then
    rm -rf targets/headers
fi
mkdir -p targets/headers

for version in v18.20.0 v20.12.0 v21.7.0 v22.1.0; do
    major=$(echo $version | grep -o -E "[0-9]+" | head -n 1)
    header=targets/headers/$major
    extract=targets/node-$version
    v8dir=node-$version/deps/v8/include
    mkdir -p $header

    echo Downloading node-$version
    wget -c https://nodejs.org/dist/$version/node-$version.tar.xz -P targets

    echo Extracting node-$version
    tar -xf targets/node-$version.tar.xz -C targets --wildcards "node-$version/src/*.h" "$v8dir/v8-fast-api-calls.h"

    echo Collecting header files for node-$version
    cp $extract/src/*.h $header
    cp $extract/deps/v8/include/*.h $header
    for dir in crypto permission tracing; do
        if [ -e $extract/src/$dir ]; then
            cp -r $extract/src/$dir $header/$dir
        fi
    done

    echo Patching header files for node-$version
    patch -Ntp1 --no-backup-if-mismatch -d $header < headers.patch
done

echo Moving header files to src
if [ -e src/headers ]; then
    rm -rf src/headers
fi
mv targets/headers src/headers
