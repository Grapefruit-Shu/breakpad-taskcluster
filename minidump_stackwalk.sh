#!/bin/bash
set -v -e -x

: BREAKPAD_REPO        ${BREAKPAD_REPO:=https://google-breakpad.googlecode.com/svn/trunk/}
: BREAKPAD_REV         ${BREAKPAD_REV:=HEAD}

function build()
{
    cd /tmp
    local platform=$1
    local configure_args=$2
    local make_args=$3
    local objdir=/tmp/obj-breakpad-$platform
    local install_dir=/tmp/install-breakpad-$platform
    rm -rf $objdir
    mkdir $objdir
    rm -rf $install_dir
    mkdir $install_dir
    cd $objdir
    CFLAGS=-O2 CXXFLAGS=-O2 /tmp/google-breakpad/configure --prefix=$install_dir --disable-tools $configure_args
    make -j`grep -c ^processor /proc/cpuinfo` $make_args
    make install-strip $make_args
    cp $install_dir/bin/minidump_stackwalk* /tmp/stackwalker/minidump_stackwalk-$platform
}

function linux64()
{
    build linux64
}

function linux32()
{
    build linux32 "--enable-m32"
}

function macosx()
{
    cd /tmp
    python tooltool.py --manifest=macosx-sdk.manifest --url=http://relengapi fetch
    tar xjf MacOSX10.7.sdk.tar.bz2
    local FLAGS="-target x86_64-apple-darwin10 -mlinker-version=136 -B /tmp/cctools/bin -isysroot /tmp/MacOSX10.7.sdk"
    export CC="clang $FLAGS"
    export CXX="clang++ $FLAGS"
    local old_path=$PATH
    export PATH=$PATH:/tmp/cctools/bin/
    export LD_LIBRARY_PATH=/usr/lib/llvm-3.5/lib/

    build macosx "--host=x86_64-apple-darwin10" "AR=/tmp/cctools/bin/x86_64-apple-darwin10-ar"

    unset CC CXX LD_LIBRARY_PATH
    export PATH=$old_path
}

function win32()
{
    build win32 "--host=i686-w64-mingw32"
}

cd /tmp
mkdir -p stackwalker
if ! test -d google-breakpad; then
    svn checkout -r $BREAKPAD_REV $BREAKPAD_REPO google-breakpad
else
    (cd google-breakpad; svn checkout -r $BREAKPAD_REV)
fi
(cd google-breakpad; svn info)
linux64
linux32
macosx
win32
