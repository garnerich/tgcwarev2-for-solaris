#!/bin/bash
#
# This is a generic build.sh script
# It can be used nearly unmodified with many packages
# 
# build.sh helper functions
. ${BUILDPKG_BASE}/scripts/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=tcl
version=8.4.19
pkgver=1
source[0]=$topdir$version-src.tar.gz
# If there are no patches, simply comment this
#patch[0]=

# Source function library
. ${BUILDPKG_BASE}/scripts/buildpkg.functions

# Global settings
export LDFLAGS="-L$prefix/lib -R$prefix/lib"
configure_args="--prefix=$prefix --mandir=$prefix/$_mandir --disable-symbols --enable-man-symlinks"
topsrcdir=$topdir$version

majorver="${version%.*}"

reg prep
prep()
{
    generic_prep
}

reg build
build()
{
    generic_build unix
}

reg install
install()
{
    generic_install DESTDIR unix
    doc license.terms changes README
    setdir ${stagedir}${prefix}/${_bindir}
    ${__ln} -s tclsh${majorver} tclsh
    setdir ${stagedir}${prefix}/${_libdir}
    ${__ln} -s libtcl${majorver}.so libtcl.so

    # Grab headers
    ${__mkdir} -p ${stagedir}${prefix}/${_includedir}/tcl-private/{generic,unix}
    setdir ${srcdir}/${topsrcdir}
    ${__find} generic unix -name "*.h" -print | ${__tar} -T - -cf - | (cd ${stagedir}${prefix}/${_includedir}/tcl-private; ${__tar} -xvBpf -)
    ( cd ${stagedir}${prefix}/${_includedir}
        for i in *.h ; do
            [ -f ${stagedir}${prefix}/${_includedir}/tcl-private/generic/$i ] && ln -sf ../../$i ${stagedir}${prefix}/${_includedir}/tcl-private/generic ;
        done
    )
    # Cleanup references to the build
    ${__gsed} -i "s|${srcdir}/${topsrcdir}/unix|${prefix}/${_libdir}|" ${stagedir}${prefix}/${_libdir}/tclConfig.sh
    ${__gsed} -i "s|${srcdir}/${topsrcdir}|${prefix}/${_includedir}/tcl-private|" ${stagedir}${prefix}/${_libdir}/tclConfig.sh
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
