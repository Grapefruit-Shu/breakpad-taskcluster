FROM ubuntu:15.10
MAINTAINER Ted Mielczarek <ted@mielczarek.org>

RUN apt-get clean && dpkg --add-architecture i386 && apt-get update && apt-get install -qq mingw-w64 git build-essential autoconf subversion gcc-multilib g++-multilib clang wget mercurial libcurl4-openssl-dev libstdc++6:i386
ADD build.sh /tmp/
ADD cctools.tar.gz /tmp/
ADD macosx-sdk.manifest /tmp/
ADD tooltool.py /tmp/
ADD build-prereqs.sh /tmp/
RUN chmod +x /tmp/tooltool.py /tmp/build.sh /tmp/build-prereqs.sh
RUN /tmp/build-prereqs.sh
