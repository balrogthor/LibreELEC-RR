# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="open-vm-tools"
PKG_VERSION="stable-11.0.0"
PKG_SHA256="e5c1929cef0fe6db76c8e5700a2160c31020651ab7a0618d5ac402d8e50d2ac7"
PKG_ARCH="x86_64"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/vmware/open-vm-tools"
PKG_URL="https://github.com/vmware/open-vm-tools/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain fuse glib:host glib libdnet libtirpc"
PKG_LONGDESC="open-vm-tools: open source implementation of VMware Tools"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--disable-docs \
                           --disable-tests \
                           --disable-deploypkg \
                           --without-pam \
                           --without-gtk2 \
                           --without-gtkmm \
                           --without-ssl \
                           --without-x \
                           --without-xerces \
                           --without-icu \
                           --without-kernel-modules \
                           --with-udev-rules-dir=/usr/lib/udev/rules.d/ \
                           --with-sysroot=$SYSROOT_PREFIX"

post_unpack() {
  mv $PKG_BUILD/$PKG_NAME/* $PKG_BUILD/

  sed -e 's|.*common-agent/etc/config/Makefile.*||' -i $PKG_BUILD/configure.ac

  mkdir -p $PKG_BUILD/common-agent/etc/config

  # Hack to allow package to be bumped without linking against old libraries
  rm -f ${SYSROOT_PREFIX}/usr/lib/libvmtools*
}

pre_configure_target() {
  export LIBS="-ldnet -ltirpc"
}

post_makeinstall_target() {
  rm -rf $INSTALL/sbin
  rm -rf $INSTALL/usr/share
  rm -rf $INSTALL/etc/vmware-tools/scripts/vmware/network

  find $INSTALL/etc/vmware-tools/ -type f | xargs sed -i '/.*expr.*/d'
}

post_install() {
  enable_service vmtoolsd.service
  enable_service vmware-vmblock-fuse.service
}
