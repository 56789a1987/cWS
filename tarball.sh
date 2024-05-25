PLATFORM=$(node -p "['node-v' + process.versions.modules, process.platform, process.arch].join('-')")
TARNAME=cws-$BUILD_TAG-$PLATFORM.tar.gz

tar -czvf "$TARNAME" dist/bindings/*.node

if [ $? -ne 0 ]; then
  echo "failed to make tarball $TARNAME"
  exit 1;
else
  echo "asset_name=$TARNAME" >> $GITHUB_OUTPUT
fi
