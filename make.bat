REM Fix this path !!!
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64

set v108=v18.20.0
set v115=v20.12.0
set v120=v21.7.0
set v127=v22.1.0

if not exist targets (
  mkdir targets

  wget -c https://nodejs.org/dist/%v108%/node-%v108%-headers.tar.gz -P targets
  tar -xzf targets/node-%v108%-headers.tar.gz -C targets
  wget https://nodejs.org/dist/%v108%/win-x64/node.lib -O targets/node-%v108%/node.lib

  wget -c https://nodejs.org/dist/%v115%/node-%v115%-headers.tar.gz -P targets
  tar -xzf targets/node-%v115%-headers.tar.gz -C targets
  wget https://nodejs.org/dist/%v115%/win-x64/node.lib -O targets/node-%v115%/node.lib

  wget -c https://nodejs.org/dist/%v120%/node-%v120%-headers.tar.gz -P targets
  tar -xzf targets/node-%v120%-headers.tar.gz -C targets
  wget https://nodejs.org/dist/%v120%/win-x64/node.lib -O targets/node-%v120%/node.lib

  wget -c https://nodejs.org/dist/%v127%/node-%v127%-headers.tar.gz -P targets
  tar -xzf targets/node-%v127%-headers.tar.gz -C targets
  wget https://nodejs.org/dist/%v127%/win-x64/node.lib -O targets/node-%v127%/node.lib
)

cl /std:c++17 /I src/headers/18 /I targets/node-%v108%/include/node /I targets/node-%v108%/deps/uv/include /I targets/node-%v108%/deps/v8/include /I targets/node-%v108%/deps/openssl/openssl/include /I targets/node-%v108%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_108.node src/*.cpp targets/node-%v108%/node.lib
cl /std:c++17 /I src/headers/20 /I targets/node-%v115%/include/node /I targets/node-%v115%/deps/uv/include /I targets/node-%v115%/deps/v8/include /I targets/node-%v115%/deps/openssl/openssl/include /I targets/node-%v115%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_115.node src/*.cpp targets/node-%v115%/node.lib
cl /std:c++17 /I src/headers/21 /I targets/node-%v120%/include/node /I targets/node-%v120%/deps/uv/include /I targets/node-%v120%/deps/v8/include /I targets/node-%v120%/deps/openssl/openssl/include /I targets/node-%v120%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_120.node src/*.cpp targets/node-%v120%/node.lib
cl /std:c++17 /I src/headers/22 /I targets/node-%v127%/include/node /I targets/node-%v127%/deps/uv/include /I targets/node-%v127%/deps/v8/include /I targets/node-%v127%/deps/openssl/openssl/include /I targets/node-%v127%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_127.node src/*.cpp targets/node-%v127%/node.lib

del ".\*.obj"
del ".\dist\bindings\*.exp"
del ".\dist\bindings\*.lib"