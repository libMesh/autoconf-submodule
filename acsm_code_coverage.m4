# SYNOPSIS
#
#   Add code coverage support with gcov/lcov.
#
#   ACSM_CODE_COVERAGE()
#
# DESCRIPTION
#
#   Provides a --enable-coverage option which checks for available
#   gcov/lcov binaries and provides ENABLE_CODE_COVERAGE conditional.
#
# LAST MODIFICATION
#
#   git log -n1 m4/coverage.m4
#
# COPYLEFT
#
#   Copyright (c) 2012-2025 Roy H. Stogner <Roy.Stogner@inl.gov>
#   Copyright (c) 2010 Karl W. Schulz <karl@ices.utexas.edu>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.

AC_DEFUN([ACSM_CODE_COVERAGE],
[

AC_ARG_ENABLE(coverage, AS_HELP_STRING([--enable-coverage],[configure code coverage analysis tools]))

HAVE_GCOV_TOOLS=0

GCOV_FLAGS=""

AS_IF([test "x$enable_coverage" = "xyes"],
  [
   # ----------------------------
   # Check for gcov/lcov binaries
   # ----------------------------

   AC_CHECK_PROG(have_gcov,gcov, yes, no)

   if test "x$have_gcov" = "xno"; then
      AC_MSG_ERROR([

      gcov coverage testing tool not found. Please install or update
      your PATH accordingly prior to enabling code coverage features.

      ])
   fi

   # ----------------------------------
   # include coverage compiler options
   # ----------------------------------

   HAVE_GCOV_TOOLS=1
   GCOV_FLAGS="-fprofile-arcs -ftest-coverage --coverage"
   GCOV_LDFLAGS="--coverage"

   ac_coverage_save_LDFLAGS="$LDFLAGS"

   # Test for C...

   AS_IF([test "x$CC" != "x"],
         [AC_MSG_CHECKING([for C code coverage support])
          ac_coverage_save_CFLAGS="$CFLAGS"

          AC_LANG_PUSH([C])
          CFLAGS="${GCOV_FLAGS} ${CFLAGS}"
          AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],[])],[],
            [AC_MSG_ERROR([unable to compile C with code coverage ($CC --coverage)])])
          LDFLAGS="${ac_coverage_save_LDFLAGS} ${GCOV_LDFLAGS}"
          AC_LINK_IFELSE([AC_LANG_PROGRAM([],[])],[],
            [
             AC_MSG_NOTICE([unable to link C with coverage ($GCOV_LDFLAGS)])
             GCOV_LDFLAGS="--coverage -lgcov"
             LDFLAGS="${ac_coverage_save_LDFLAGS} ${GCOV_LDFLAGS}"
             AC_LINK_IFELSE([AC_LANG_PROGRAM([],[])],[],
               [AC_MSG_ERROR([also unable to link C with coverage ($GCOV_LDFLAGS)])])
            ])
          AC_LANG_POP([C])
          AC_MSG_RESULT(yes)
         ],
         [AC_MSG_NOTICE([CC not set - skipping C code coverage checks])])

   # Test for C++...

   AS_IF([test "x$CXX" != "x"],
         [AC_MSG_CHECKING([for C++ code coverage support])
          ac_coverage_save_CXXFLAGS="$CXXFLAGS"

          AC_LANG_PUSH([C++])
          CXXFLAGS="${GCOV_FLAGS} ${CXXFLAGS}"
          AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],[])],[],
            [AC_MSG_ERROR([unable to compile C++ with code coverage ($CXX --coverage)])])
          LDFLAGS="${ac_coverage_save_LDFLAGS} ${GCOV_LDFLAGS}"
          AC_LINK_IFELSE([AC_LANG_PROGRAM([],[])],[],
            [
             AS_IF([test "$GCOV_LDFLAGS" = "--coverage -lgcov"],
                   [AC_MSG_ERROR([unable to link C++ with coverage ($GCOV_LDFLAGS)])],
                   [AC_MSG_NOTICE([unable to link C++ with coverage ($GCOV_LDFLAGS)])
                    GCOV_LDFLAGS="--coverage -lgcov"
                    LDFLAGS="${ac_coverage_save_LDFLAGS} ${GCOV_LDFLAGS}"
                    AC_LINK_IFELSE([AC_LANG_PROGRAM([],[])],[],
                       [AC_MSG_ERROR([also unable to link C++ with coverage ($GCOV_LDFLAGS)])])
                   ])
            ])
          AC_LANG_POP([C++])
          AC_MSG_RESULT(yes)
         ],
         [AC_MSG_NOTICE([CXX not set - skipping C++ code coverage checks])])

   # Test for Fortran...

   AS_IF([test "x$FC" != "x"],
         [AC_MSG_CHECKING([for Fortran code coverage support])
          ac_coverage_save_FCFLAGS="$FCFLAGS"

          AC_LANG_PUSH([Fortran])
          FCFLAGS="${GCOV_FLAGS} ${FCFLAGS}"
          AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],[])],[],
            [AC_MSG_ERROR([unable to compile Fortran with code coverage ($FC --coverage)])])
          LDFLAGS="${ac_coverage_save_LDFLAGS} ${GCOV_LDFLAGS}"
          AC_LINK_IFELSE([AC_LANG_PROGRAM([],[])],[],
            [
             AS_IF([test "$GCOV_LDFLAGS" = "--coverage -lgcov"],
                   [AC_MSG_ERROR([unable to link Fortran with coverage ($GCOV_LDFLAGS)])],
                   [AC_MSG_NOTICE([unable to link Fortran with coverage ($GCOV_LDFLAGS)])
                    GCOV_LDFLAGS="--coverage -lgcov"
                    LDFLAGS="${ac_coverage_save_LDFLAGS} ${GCOV_LDFLAGS}"
                    AC_LINK_IFELSE([AC_LANG_PROGRAM([],[])],[],
                       [AC_MSG_ERROR([also unable to link Fortran with coverage ($GCOV_LDFLAGS)])])
                   ])
            ])
          AC_LANG_POP([Fortran])
          AC_MSG_RESULT(yes)
         ],
         [AC_MSG_NOTICE([FC not set - skipping Fortran code coverage checks])])
  ])

AC_SUBST(GCOV_FLAGS)
AC_SUBST(GCOV_LDFLAGS)
AC_SUBST(HAVE_GCOV_TOOLS)
AM_CONDITIONAL(CODE_COVERAGE_ENABLED,test x$HAVE_GCOV_TOOLS = x1)

])
