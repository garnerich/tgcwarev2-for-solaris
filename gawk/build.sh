#!/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=gawk
version=4.0.2
pkgver=2
source[0]=ftp://ftp.sunet.se/pub/gnu/${topdir}/${topdir}-${version}.tar.xz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I$prefix/include"
export LDFLAGS="-L$prefix/lib -R$prefix/lib"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build
}

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
    doc AUTHORS COPYING FUTURES LIMITATIONS NEWS POSIX.STD PROBLEMS README

   # We don't want versioned hardlinks
   ${__rm} -f ${stagedir}${prefix}/${_bindir}/*-${version}
   # No awk link either (will be in $_gnudir instead)
   ${__rm} -f ${stagedir}${prefix}/${_bindir}/awk

   # Setup gnu link
   gnu_link gawk
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
