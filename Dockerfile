FROM ubuntu:15.10
MAINTAINER Ted Mielczarek <ted@mielczarek.org>

RUN apt-get clean && dpkg --add-architecture i386 && apt-get update && apt-get install -qq mingw-w64 git build-essential autoconf subversion gcc-multilib g++-multilib clang wget mercurial libcurl4-openssl-dev libstdc++6:i386
ADD cctools.tar.gz /tmp/
ADD clang.manifest /tmp/
ADD tooltool.py /tmp/
RUN chmod +x /tmp/tooltool.py
ADD build-prereqs.sh /tmp/
RUN chmod +x /tmp/build-prereqs.sh
RUN /tmp/build-prereqs.sh
ADD macosx-sdk.manifest /tmp/
ADD build.sh /tmp/
RUN chmod +x /tmp/build.sh
