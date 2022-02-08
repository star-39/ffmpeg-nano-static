#!/bin/bash

cd

curl -Lo ffmpeg.tar.gz "https://git.ffmpeg.org/gitweb/ffmpeg.git/snapshot/master.tar.gz" && \
mkdir ffmpeg && tar -xvf ffmpeg.tar.gz --strip-components=1 -C ffmpeg

curl -Lo x264.tar.gz "https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.gz" && \
mkdir x264 && tar -xvf x264.tar.gz --strip-components=1 -C x264

cd

export LDFLAGS="-L/usr/lib -L/usr/lib64 -L/usr/local/lib -L/usr/local/lib64"
export PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig" 


cd x264 
./configure --enable-static --disable-cli 
make -j$(nproc)
make install
cd

cd ffmpeg
./configure \
  --extra-cflags="-I/usr/local/include -I/usr/lib/include" \
  --extra-cxxflags="-I/usr/local/include -I/usr/lib/include" \
  --extra-ldflags="-L/usr/local/lib -L/usr/local/lib64 -L/usr/lib -L/usr/lib64" \
  --extra-libs=-pthread \
  --disable-doc \
  --enable-gpl \
  --enable-version3 \
  --enable-nonfree \
  --enable-libx264 

make -j$(nproc)
make install
cd


