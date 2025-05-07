#!/bin/bash

set -eu

mkdir -p downloads
rm -rf downloads/headers
mkdir -p downloads/headers

for version in v18.20.0 v20.18.0 v22.14.0 v23.10.0 v24.0.0; do
    major=$(echo $version | grep -o -E "[0-9]+" | head -n 1)
    headers_dir=downloads/headers/$major
    extract_dir=downloads/node-$version
    tarball_path=downloads/node-$version.tar.xz
    mkdir -p $headers_dir

    echo Downloading node-$version
    wget -c "https://nodejs.org/dist/$version/node-$version.tar.xz" -P downloads

    echo Extracting node-$version
    if [ $major -ge 24 ]; then
        tar -xf $tarball_path -C downloads --wildcards "node-$version/src/*.h" \
            "node-$version/deps/v8/include/v8-external-memory-accounter.h" \
            "node-$version/deps/v8/include/v8-fast-api-calls.h" \
            "node-$version/deps/v8/include/v8-inspector.h" \
            "node-$version/deps/ncrypto/ncrypto.h"
    elif [ $major -ge 22 ]; then
        tar -xf $tarball_path -C downloads --wildcards "node-$version/src/*.h" \
            "node-$version/deps/v8/include/v8-fast-api-calls.h" \
            "node-$version/deps/ncrypto/ncrypto.h"
    else
        tar -xf $tarball_path -C downloads --wildcards "node-$version/src/*.h" \
            "node-$version/deps/v8/include/v8-fast-api-calls.h"
    fi

    echo Getting header files for node-$version
    cp $extract_dir/src/*.h $headers_dir
    cp $extract_dir/deps/v8/include/*.h $headers_dir

    for sub_dir in crypto permission tracing; do
        if [ -e $extract_dir/src/$sub_dir ]; then
            cp -r $extract_dir/src/$sub_dir $headers_dir/$sub_dir
        fi
    done

    if [ $major -ge 22 ]; then
        cp $extract_dir/deps/ncrypto/*.h $headers_dir/crypto
    fi

    echo Patching header files for node-$version
    patch -Ntp1 --no-backup-if-mismatch -d $headers_dir < headers.patch
done

echo Moving header files to src
rm -rf src/headers
mv downloads/headers src/headers
