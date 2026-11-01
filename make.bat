@echo off
setlocal

set "PATH=%PATH%;C:\msys64\usr\bin"
REM Fix this path!
call "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" amd64

set v127=v22.23.0
set v137=v24.22.0
set v147=v26.13.0
set v153=v27.0.0-alpha.0.0.0

goto :main

:download_headers
wget "https://nodejs.org/dist/%~1/node-%~1-headers.tar.gz" -O - | tar -xC targets
wget "https://nodejs.org/dist/%~1/win-x64/node.lib" -O targets/node-%~1/node.lib
exit /B %ERRORLEVEL%

:build_cpp
cl /std:c++20 /Zc:__cplusplus /I src/headers/%~1^
  /I targets/node-%~3/include/node^
  /I targets/node-%~3/deps/uv/include^
  /I targets/node-%~3/deps/v8/include^
  /I targets/node-%~3/deps/openssl/openssl/include^
  /I targets/node-%~3/deps/zlib^
  /EHsc /Ox /LD /Fedist/bindings/cws_win32_x64_%~2.node src/*.cpp targets/node-%~3/node.lib
exit /B %ERRORLEVEL%

:main
if not exist targets (
  mkdir targets

  call :download_headers %v127%
  call :download_headers %v137%
  call :download_headers %v147%
  call :download_headers %v153%
)

call :build_cpp 22 127 %v127%
call :build_cpp 24 137 %v137%
call :build_cpp 26 147 %v147%
call :build_cpp 27 153 %v153%

del ".\*.obj"
del ".\dist\bindings\*.exp"
del ".\dist\bindings\*.lib"