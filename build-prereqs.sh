#!/bin/bash

set -v -e -x

ncpu=`grep -c ^processor /proc/cpuinfo`

cd /tmp

# build a 32-bit libcurl
wget https://github.com/bagder/curl/releases/download/curl-7_44_0/curl-7.44.0.tar.bz2
tar xjf curl-7.44.0.tar.bz2
cd /tmp/curl-7.44.0
mkdir /tmp/libcurl-i386
CFLAGS=-m32 ./configure --host=i386-unknown-linux-gnu --prefix=/tmp/libcurl-i386
make -j$ncpu
make install
cd ..
rm -rf /tmp/curl-7.44.0 /tmp/curl-7.44.0.tar.bz2

# build zlib for mingw
wget https://downloads.sourceforge.net/project/libpng/zlib/1.2.8/zlib-1.2.8.tar.gz
tar xzf zlib-1.2.8.tar.gz
cd /tmp/zlib-1.2.8
mkdir /tmp/zlib-mingw
export BINARY_PATH=/tmp/zlib-mingw/bin INCLUDE_PATH=/tmp/zlib-mingw/include LIBRARY_PATH=/tmp/zlib-mingw/lib
make -f win32/Makefile.gcc PREFIX=i686-w64-mingw32- -j$ncpu
make -f win32/Makefile.gcc PREFIX=i686-w64-mingw32- install
cd ..
rm -rf /tmp/zlib-1.2.8 /tmp/zlib-1.2.8.tar.gz
