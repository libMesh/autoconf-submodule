# ===========================================================================
#     https://www.gnu.org/software/autoconf-archive/ax_split_version.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_SPLIT_VERSION
#
# DESCRIPTION
#
#   Splits a version number in the format MAJOR.MINOR.POINT into its
#   separate components.
#
#   Sets the variables.
#
# LICENSE
#
#   Copyright (c) 2020 Roy Stogner
#   Copyright (c) 2008 Tom Howard <tomhoward@users.sf.net>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 10

AC_DEFUN([AX_SPLIT_VERSION],[
    AC_REQUIRE([AC_PROG_SED])
    AX_MAJOR_VERSION=`echo "$VERSION" | $SED 's/\([[^.]][[^.]]*\).*/\1/'`
    AX_MINOR_VERSION=`echo "$VERSION" | $SED -n 's/[[^.]][[^.]]*.\([[^.]][[^.]]*\).*/\1/p'`
    AS_IF([test "x$AX_MINOR_VERSION" = "x"], [AX_MINOR_VERSION=0])
    AX_POINT_VERSION=`echo "$VERSION" | $SED -n 's/[[^.]][[^.]]*.[[^.]][[^.]]*.\(.*\)/\1/p'`
    AS_IF([test "x$AX_POINT_VERSION" = "x"], [AX_POINT_VERSION=0])
    AC_MSG_CHECKING([Major version])
    AC_MSG_RESULT([$AX_MAJOR_VERSION])
    AC_MSG_CHECKING([Minor version])
    AC_MSG_RESULT([$AX_MINOR_VERSION])
    AC_MSG_CHECKING([Point version])
    AC_MSG_RESULT([$AX_POINT_VERSION])
])
