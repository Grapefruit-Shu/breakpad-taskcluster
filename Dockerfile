FROM ubuntu:14.10
MAINTAINER Ted Mielczarek <ted@mielczarek.org>

RUN apt-get clean && apt-get update && apt-get install -qq mingw-w64 git build-essential autoconf subversion gcc-multilib g++-multilib clang wget
ADD build.sh /tmp/
ADD cctools.tar.gz /tmp/
ADD macosx-sdk.manifest /tmp/
ADD tooltool.py /tmp/
RUN chmod +x /tmp/tooltool.py /tmp/build.sh
