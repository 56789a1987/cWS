REM Fix this path !!!
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64

set v64=v10.20.1
set v72=v12.18.2
set v83=v14.15.0
set v93=v16.13.0

if not exist targets (
  mkdir targets
  curl https://nodejs.org/dist/%v64%/node-%v64%-headers.tar.gz | tar xz -C targets
  curl https://nodejs.org/dist/%v64%/win-x64/node.lib > targets/node-%v64%/node.lib
  curl https://nodejs.org/dist/%v72%/node-%v72%-headers.tar.gz | tar xz -C targets
  curl https://nodejs.org/dist/%v72%/win-x64/node.lib > targets/node-%v72%/node.lib
  curl https://nodejs.org/dist/%v83%/node-%v83%-headers.tar.gz | tar xz -C targets
  curl https://nodejs.org/dist/%v83%/win-x64/node.lib > targets/node-%v83%/node.lib
  curl https://nodejs.org/dist/%v93%/node-%v93%-headers.tar.gz | tar xz -C targets
  curl https://nodejs.org/dist/%v93%/win-x64/node.lib > targets/node-%v93%/node.lib
)

cl /I targets/node-%v64%/include/node /I targets/node-%v64%/deps/uv/include /I targets/node-%v64%/deps/v8/include /I targets/node-%v64%/deps/openssl/openssl/include /I targets/node-%v64%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_64.node src/*.cpp targets/node-%v64%/node.lib
cl /I targets/node-%v72%/include/node /I targets/node-%v72%/deps/uv/include /I targets/node-%v72%/deps/v8/include /I targets/node-%v72%/deps/openssl/openssl/include /I targets/node-%v72%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_72.node src/*.cpp targets/node-%v72%/node.lib
cl /I targets/node-%v83%/include/node /I targets/node-%v83%/deps/uv/include /I targets/node-%v83%/deps/v8/include /I targets/node-%v83%/deps/openssl/openssl/include /I targets/node-%v83%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_83.node src/*.cpp targets/node-%v83%/node.lib
cl /I src/headers/16 /I targets/node-%v93%/include/node /I targets/node-%v93%/deps/uv/include /I targets/node-%v93%/deps/v8/include /I targets/node-%v93%/deps/openssl/openssl/include /I targets/node-%v93%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_93.node src/*.cpp targets/node-%v93%/node.lib

del ".\*.obj"
del ".\dist\bindings\*.exp"
del ".\dist\bindings\*.lib"