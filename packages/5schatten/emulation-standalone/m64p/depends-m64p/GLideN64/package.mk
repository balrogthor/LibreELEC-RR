# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="GLideN64"
PKG_VERSION="2b7f78c9f8ecdaab6bbee8c0cbf4a7f607d1994e"
PKG_SHA256="ed7f0b69f6ff365c8a668dbc413dc605aeab039dd838c1ce0ef5bf23735ede47"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/gonetz/GLideN64"
PKG_URL="https://github.com/gonetz/GLideN64/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain freetype:host zlib"
PKG_LONGDESC="A new generation, open-source graphics plugin for N64 emulators."
PKG_TOOLCHAIN="cmake"

# workaround for shader cache crash issue github.com/gonetz/GLideN64/issues/1665
if [ "${PROJECT}" = "RPi" ]; then
  PKG_PATCH_DIRS="${PROJECT}"
fi

pre_configure_target() {
  PKG_CMAKE_SCRIPT="$PKG_BUILD/src/CMakeLists.txt"
  PKG_CMAKE_OPTS_TARGET="-DUSE_SYSTEM_LIBS=On \
                         -DVEC4_OPT=On \
                         -DCRC_OPT=On \
                         -DMUPENPLUSAPI=On"
  # Fix revision header
  PKG_REV_H=$PKG_BUILD/src/Revision.h
  echo "#define PLUGIN_REVISION" ""\"${PKG_VERSION:0:10}""\"     > ${PKG_REV_H}
  echo "#define PLUGIN_REVISION_W" "L"\"${PKG_VERSION:0:10}""\" >> ${PKG_REV_H}

  rm -rf $PKG_BUILD/src/GLideNHQ/inc

  # NEON Support
  if target_has_feature neon; then
    PKG_CMAKE_OPTS_TARGET+=" -DNEON_OPT=On"
  fi
}

makeinstall_target() {
 :
}