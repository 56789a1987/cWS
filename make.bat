REM Fix this path !!!
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64

set v127=v22.21.0
set v137=v24.12.0
set v141=v25.9.0
set v147=v26.0.0

if not exist targets (
  mkdir targets

  wget -c https://nodejs.org/dist/%v127%/node-%v127%-headers.tar.gz -P targets
  tar -xzf targets/node-%v127%-headers.tar.gz -C targets
  wget https://nodejs.org/dist/%v127%/win-x64/node.lib -O targets/node-%v127%/node.lib

  wget -c https://nodejs.org/dist/%v137%/node-%v137%-headers.tar.gz -P targets
  tar -xzf targets/node-%v137%-headers.tar.gz -C targets
  wget https://nodejs.org/dist/%v137%/win-x64/node.lib -O targets/node-%v137%/node.lib

  wget -c https://nodejs.org/dist/%v141%/node-%v141%-headers.tar.gz -P targets
  tar -xzf targets/node-%v141%-headers.tar.gz -C targets
  wget https://nodejs.org/dist/%v141%/win-x64/node.lib -O targets/node-%v141%/node.lib

  wget -c https://nodejs.org/dist/%v147%/node-%v147%-headers.tar.gz -P targets
  tar -xzf targets/node-%v147%-headers.tar.gz -C targets
  wget https://nodejs.org/dist/%v147%/win-x64/node.lib -O targets/node-%v147%/node.lib
)

cl /std:c++20 /I src/headers/22 /I targets/node-%v127%/include/node /I targets/node-%v127%/deps/uv/include /I targets/node-%v127%/deps/v8/include /I targets/node-%v127%/deps/openssl/openssl/include /I targets/node-%v127%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_x64_127.node src/*.cpp targets/node-%v127%/node.lib
cl /std:c++20 /I src/headers/24 /I targets/node-%v137%/include/node /I targets/node-%v137%/deps/uv/include /I targets/node-%v137%/deps/v8/include /I targets/node-%v137%/deps/openssl/openssl/include /I targets/node-%v137%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_x64_137.node src/*.cpp targets/node-%v137%/node.lib
cl /std:c++20 /I src/headers/25 /I targets/node-%v141%/include/node /I targets/node-%v141%/deps/uv/include /I targets/node-%v141%/deps/v8/include /I targets/node-%v141%/deps/openssl/openssl/include /I targets/node-%v141%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_x64_141.node src/*.cpp targets/node-%v141%/node.lib
cl /std:c++20 /I src/headers/26 /I targets/node-%v147%/include/node /I targets/node-%v147%/deps/uv/include /I targets/node-%v147%/deps/v8/include /I targets/node-%v147%/deps/openssl/openssl/include /I targets/node-%v147%/deps/zlib /EHsc /Ox /LD /Fedist/bindings/cws_win32_x64_147.node src/*.cpp targets/node-%v147%/node.lib

del ".\*.obj"
del ".\dist\bindings\*.exp"
del ".\dist\bindings\*.lib"