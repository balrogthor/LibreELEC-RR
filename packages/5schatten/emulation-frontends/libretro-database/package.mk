# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 0riginally created by Escalade (https://github.com/escalade)
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="libretro-database"
PKG_VERSION="139ad20"
PKG_SHA256="94c9d4babefad3b1a2290fbbe4915244cde7a54cdc69675c61d00d6744cb03ab"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/libretro/libretro-database"
PKG_URL="https://github.com/libretro/libretro-database/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="emulation"
PKG_SHORTDESC="Repository containing cheatcode files, content data files, etc."
PKG_LONGDESC="Repository containing cheatcode files, content data files, etc."
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  cd ../
  rm -rf .$TARGET_NAME
}

makeinstall_target() {
  make install DESTDIR=$INSTALL PREFIX=/usr
}

post_makeinstall_target() {
  mv $INSTALL/usr/share/libretro $INSTALL/usr/share/retroarch
  rm $INSTALL/usr/share/retroarch/database/rdb/MAME.rdb
  rm $INSTALL/usr/share/retroarch/database/rdb/MAME\ 2000.rdb
  rm $INSTALL/usr/share/retroarch/database/rdb/MAME\ 2010.rdb
}