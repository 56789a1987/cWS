CPP_SHARED := -DUSE_LIBUV -std=c++20 -O3 -I ./src/headers/$$MAJOR -shared -fPIC ./src/Extensions.cpp ./src/Group.cpp ./src/Networking.cpp ./src/Hub.cpp ./src/cSNode.cpp ./src/WebSocket.cpp ./src/HTTPSocket.cpp ./src/Socket.cpp ./src/Epoll.cpp ./src/Addon.cpp
CPP_OSX := -stdlib=libc++ -mmacosx-version-min=10.13 -undefined dynamic_lookup

VER_108 := v18.20.0
VER_115 := v20.18.0
VER_127 := v22.10.0
VER_131 := v23.0.0

default:
	make targets
	NODE=targets/node-$(VER_108) MAJOR=18 ABI=108 make `(uname -s)`
	NODE=targets/node-$(VER_115) MAJOR=20 ABI=115 make `(uname -s)`
	NODE=targets/node-$(VER_127) MAJOR=22 ABI=127 make `(uname -s)`
	NODE=targets/node-$(VER_131) MAJOR=23 ABI=131 make `(uname -s)`
	for f in dist/bindings/*.node; do chmod +x $$f; done
targets:
	mkdir targets
	curl https://nodejs.org/dist/$(VER_108)/node-$(VER_108)-headers.tar.gz | tar xz -C targets
	curl https://nodejs.org/dist/$(VER_115)/node-$(VER_115)-headers.tar.gz | tar xz -C targets
	curl https://nodejs.org/dist/$(VER_127)/node-$(VER_127)-headers.tar.gz | tar xz -C targets
	curl https://nodejs.org/dist/$(VER_131)/node-$(VER_131)-headers.tar.gz | tar xz -C targets

Linux:
	g++ $(CPP_SHARED) -static-libstdc++ -static-libgcc -I $$NODE/include/node -I $$NODE/src -I $$NODE/deps/uv/include -I $$NODE/deps/v8/include -I $$NODE/deps/openssl/openssl/include -I $$NODE/deps/zlib -s -o dist/bindings/cws_linux_$$ABI.node
Darwin:
	g++ $(CPP_SHARED) $(CPP_OSX) -I $$NODE/include/node -I src/headers/$$MAJOR -o dist/bindings/cws_darwin_$$ABI.node
