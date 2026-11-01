BINARY=$(node -p "['cws', process.platform, process.arch, process.versions.modules].join('_') + '.node'")
PLATFORM=$(node -p "['node-v' + process.versions.modules, process.platform, process.arch].join('-')")
TARNAME=cws-$BUILD_TAG-$PLATFORM.tar.gz

COPYFILE_DISABLE=1 tar -czvf "$TARNAME" dist/bindings/$BINARY

if [ $? -ne 0 ]; then
  echo "failed to make tarball $TARNAME"
  exit 1;
else
  echo "asset_name=$TARNAME" >> $GITHUB_OUTPUT
fi
