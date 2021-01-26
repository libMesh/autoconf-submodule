# SYNOPSIS
#
#   ACSM_CXX_COMPILER_STANDARD([MIN_VERSION], [MAX_VERSION], [ext|noext])
#
# DESCRIPTION
#
#   Check for baseline language coverage in the compiler for a
#   version of the C++ standard in between the specified MIN_VERSION
#   (which defaults to 2011) and MAX_VERSION (which defaults to 2017).
#
#   These defaults may be updated by --cxx-std-min, --cxx-std-max, or
#   --cxx-std (to set both) options to configure.
#
#   Setting a MAX_VERSION below a compiler default standard does not
#   currently override that standard.
#
#   Currently this macro is capable of searching for C++11, C++14,
#   and/or C++17 support.
#
#   The third argument, if specified, indicates whether you insist on
#   extended modes (e.g. -std=gnu++14) or strict conformance modes
#   (e.g. -std=c++14).  If neither is specified, you get whatever
#   works, with preference for an extended mode.
#
#   If necessary, add switches to CXX and CXXCPP to enable support for
#   a detected standard.  If no acceptable standard is detected, error
#   out.
#
# LICENSE
#
#   Copyright (c) 2021 Roy Stogner <Roy.Stogner@inl.gov>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 1

AC_DEFUN([ACSM_CXX_COMPILER_STANDARD], [dnl

acsm_CXX_STD_MIN="$1"
m4_if([$1], [], [acsm_CXX_STD_MIN=2011])
acsm_CXX_STD_MAX="$2"
m4_if([$2], [], [acsm_CXX_STD_MAX=2017])

m4_if([$3], [], [],
      [$3], [ext], [],
      [$3], [noext], [],
      [m4_fatal([invalid third argument `$3' to ACSM_CXX_COMPILER_STANDARD])])dnl
# --------------------------------------------------------------
# How new a C++ standard should we ask for?
# --------------------------------------------------------------
AC_ARG_WITH([cxx-std-max],
            AS_HELP_STRING([--with-cxx-std-max@<:@=ARG@:>@],
                           [Maximum C++ standard year to request, 2011+; this does not override your compiler default]),
            [
              AS_IF([test "$withval" -ge 2011],
                    [acsm_CXX_STD_MAX="$withval"],
                    [AC_MSG_ERROR(${withval} for --with-cxx-std-max must be an integer >= 2011)])
            ])

# --------------------------------------------------------------
# How new a C++ standard should we insist upon?
# --------------------------------------------------------------
AC_ARG_WITH([cxx-std-min],
            AS_HELP_STRING([--with-cxx-std-min@<:@=ARG@:>@],
                           [Minimum C++ standard year to require; default 2011]),
            [
              AS_IF([test "$withval" -ge 2011],
                    [acsm_CXX_STD_MIN="$withval"],
                    [AC_MSG_ERROR(${withval} for --with-cxx-std-min must be an integer >= 2011)])
              AS_IF([test "$withval" -gt 2017],
                    [AC_MSG_ERROR(${withval} for --with-cxx-std-min must be an integer <= 2017)])
            ])

# --------------------------------------------------------------
# Semantic sugar to insist upon a specific standard easily
# --------------------------------------------------------------
AC_ARG_WITH([cxx-std],
            AS_HELP_STRING([--with-cxx-std@<:@=ARG@:>@],
                           [Exact C++ standard year to require]),
            [
              AS_IF([test "$withval" -ge 2011],
                    [acsm_CXX_STD_MAX="$withval"
                     acsm_CXX_STD_MIN="$withval"],
                    [AC_MSG_ERROR(${withval} for --with-cxx-std must be an integer >= 2011)])
            ])

AS_IF([test "$acsm_CXX_STD_MAX" -ge "$acsm_CXX_STD_MIN"],
      [AC_MSG_NOTICE([Seeking a C++ standard between "$acsm_CXX_STD_MIN" and "$acsm_CXX_STD_MAX"])],
      [AC_MSG_ERROR(Maximum C++ standard "$acsm_CXX_STD_MAX" must be at least minimum "$acsm_CXX_STD_MIN")])

acsm_found_cxx=0
acsm_cxx_version=0

AS_IF([test "$acsm_found_cxx" = "0"],
  [
  AS_IF([test 2017 -le "$acsm_CXX_STD_MAX"],
    [
    AS_IF([test 2017 -gt "$acsm_CXX_STD_MIN"],
          [AX_CXX_COMPILE_STDCXX([17],[$3],[optional])],
          [AS_IF([test 2017 -eq "$acsm_CXX_STD_MIN"],
                 [AX_CXX_COMPILE_STDCXX([17],[$3],[mandatory])])])
    AS_IF([test "$HAVE_CXX17" = "1"],
          [
           AC_MSG_NOTICE([Found C++17 standard support])
           acsm_found_cxx=1
           acsm_cxx_version=17],
          [AS_IF([test "$HAVE_CXX17" = "0"],
           [AC_MSG_NOTICE([Did not find C++17 standard support])])])
    ])
  ])

AS_IF([test "$acsm_found_cxx" = "0"],
  [
  AS_IF([test 2014 -le "$acsm_CXX_STD_MAX"],
    [
    AS_IF([test 2014 -gt "$acsm_CXX_STD_MIN"],
          [AX_CXX_COMPILE_STDCXX([14],[$3],[optional])],
          [AS_IF([test 2014 -eq "$acsm_CXX_STD_MIN"],
                 [AX_CXX_COMPILE_STDCXX([14],[$3],[mandatory])])])
    AS_IF([test "$HAVE_CXX14" = "1"],
          [
           AC_MSG_NOTICE([Found C++14 standard support])
           acsm_found_cxx=1
           acsm_cxx_version=14],
          [AS_IF([test "$HAVE_CXX14" = "0"],
           [AC_MSG_NOTICE([Did not find C++14 standard support])])])
    ])
  ])

AS_IF([test "$acsm_found_cxx" = "0"],
  [
  AS_IF([test 2011 -le "$acsm_CXX_STD_MAX"],
    [
    AS_IF([test 2011 -ge "$acsm_CXX_STD_MIN"],
          [AX_CXX_COMPILE_STDCXX([11],[$3],[optional])],
          [AS_IF([test 2011 -eq "$acsm_CXX_STD_MIN"],
                 [AX_CXX_COMPILE_STDCXX([11],[$3],[mandatory])])])
    AS_IF([test "$HAVE_CXX11" = "1"],
          [
           AC_MSG_NOTICE([Found C++11 standard support])
           acsm_found_cxx=1
           acsm_cxx_version=11],
          [AS_IF([test "$HAVE_CXX11" = "0"],
           [AC_MSG_NOTICE([Did not find C++11 standard support])])])
    ])
  ])

AS_IF([test "$acsm_found_cxx" = "1"],
      [AC_MSG_NOTICE([Using support for C++$acsm_cxx_version standard])],
      [AC_MSG_ERROR([Could not find support for an acceptable C++ standard])])
])
