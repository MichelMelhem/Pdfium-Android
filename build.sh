#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

set -e

build() {
  local ARCH="$1"
  shift
  local OUT="$DIR/libmodpdfium/src/main/jniLibs/$ARCH/libmodpdfium.so"
  [ -e "$OUT" ] && return
  echo "building $OUT"
  gn gen out --args="target_os=\"android\" pdf_bundle_freetype=true pdf_is_standalone=false is_component_build=false pdf_enable_xfa=false pdf_enable_v8=false is_debug=false is_official_build=true $*"
  ninja -C out modpdfium
  mkdir -p $(dirname "$OUT") && cp out/libmodpdfium.so "$OUT"
}

#build armeabi target_cpu=\"arm\" arm_arch=\"armv5\" arm_version=5 arm_use_thumb=false arm_use_neon=false arm_fpu=\"vfpv2\" arm_float_abi=\"soft\" treat_warnings_as_errors=false
build armeabi target_cpu=\"arm\" arm_arch=\"armv6k\" arm_use_neon=false arm_use_thumb=false arm_fpu=\"vfp\" arm_float_abi=\"softfp\"
build armeabi-v7a target_cpu=\"arm\" arm_version=7
build arm64-v8a target_cpu=\"arm64\"
build x86 target_cpu=\"x86\"
build x86_64 target_cpu=\"x64\"
#build mipsel mips
#build mips64el mips64

cp public/*.h "$DIR/libmodpdfium/src/main/cpp/include/"
