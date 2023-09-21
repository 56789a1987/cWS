#!/bin/bash

mkdir targets

if [ -e targets/headers ]; then
    rm -r targets/headers
fi
mkdir targets/headers

for version in v14.21.0 v16.20.0 v18.18.0 v20.7.0; do
    major=$(echo $version | grep -o -E "[0-9]+" | head -n 1)
    header=targets/headers/$major
    extract=targets/node-$version
    v8dir=node-$version/deps/v8/include
    mkdir $header

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
    patch -Ntp1 --no-backup-if-mismatch -d $header < header.patch
done

echo Moving header files to src
if [ -e src/headers ]; then
    rm -r src/headers
fi
mv targets/headers src/headers
