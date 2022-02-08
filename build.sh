#!/bin/bash

sudo apt install -y nasm

cd

curl -Lo ffmpeg.tar.gz "https://git.ffmpeg.org/gitweb/ffmpeg.git/snapshot/master.tar.gz" && \
mkdir ffmpeg && tar -xvf ffmpeg.tar.gz --strip-components=1 -C ffmpeg

curl -Lo libvpx.tar.gz "https://chromium.googlesource.com/webm/libvpx/+archive/refs/heads/master.tar.gz" && \
mkdir libvpx && tar -xvf libvpx.tar.gz -C libvpx

cd

export LDFLAGS="-L/usr/lib -L/usr/lib64 -L/usr/local/lib -L/usr/local/lib64"
export PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig" 


cd libvpx
./configure --disable-shared --disable-unit-tests --disable-docs --disable-tools --disable-examples --disable-vp8
make -j$(nproc)
sudo make install
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
  --enable-libvpx 

make -j$(nproc)
sudo make install
cd


