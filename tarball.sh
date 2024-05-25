PLATFORM=$(node -p "['node-v' + process.versions.modules, process.platform, process.arch].join('-')")
TARNAME=cws-$BUILD_TAG-$PLATFORM.tar.gz
FILES=$(cd dist/bindings && echo *.node)

tar -C dist/bindings -czvf "$TARNAME" $FILES

if [ $? -ne 0 ]; then
  echo "failed to make tarball $TARNAME"
  exit 1;
else
  echo "::set-output name=asset_name::$TARNAME"
fi
