REM Fix this path !!!
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64

set v83=v14.21.3
set v93=v16.20.0
set v108=v18.16.0

if not exist targets (
  mkdir targets

  wget -c https://nodejs.org/dist/%v83%/node-%v83%-headers.tar.gz -P targets
  tar -xzf targets/node-%v83%-headers.tar.gz -C targets
  wget https://nodejs.org/dist/%v83%/win-x64/node.lib -O targets/node-%v83%/node.lib

  wget -c https://nodejs.org/dist/%v93%/node-%v93%-headers.tar.gz -P targets
  tar -xzf targets/node-%v93%-headers.tar.gz -C targets
  wget https://nodejs.org/dist/%v93%/win-x64/node.lib -O targets/node-%v93%/node.lib

  wget -c https://nodejs.org/dist/%v108%/node-%v108%-headers.tar.gz -P targets
  tar -xzf targets/node-%v108%-headers.tar.gz -C targets
  wget https://nodejs.org/dist/%v108%/win-x64/node.lib -O targets/node-%v108%/node.lib
)

cl /std:c++17 /I src/headers/14 /I targets/node-%v83%/include/node /I targets/node-%v83%/deps/uv/include /I targets/node-%v83%/deps/v8/include /I targets/node-%v83%/deps/openssl/openssl/include /I targets/node-%v83%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_83.node src/*.cpp targets/node-%v83%/node.lib
cl /std:c++17 /I src/headers/16 /I targets/node-%v93%/include/node /I targets/node-%v93%/deps/uv/include /I targets/node-%v93%/deps/v8/include /I targets/node-%v93%/deps/openssl/openssl/include /I targets/node-%v93%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_93.node src/*.cpp targets/node-%v93%/node.lib
cl /std:c++17 /I src/headers/18 /I targets/node-%v108%/include/node /I targets/node-%v108%/deps/uv/include /I targets/node-%v108%/deps/v8/include /I targets/node-%v108%/deps/openssl/openssl/include /I targets/node-%v108%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_108.node src/*.cpp targets/node-%v108%/node.lib

del ".\*.obj"
del ".\dist\bindings\*.exp"
del ".\dist\bindings\*.lib"