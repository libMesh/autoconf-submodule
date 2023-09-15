
dnl -------------------------------------------------------------
dnl Enable paranoid compiler warnings if requested
dnl
dnl Usage: ACSM_ENABLE_PARANOID
dnl
dnl -------------------------------------------------------------
AC_DEFUN([ACSM_ENABLE_PARANOID],
[
  AC_REQUIRE([ACSM_SET_CXX_FLAGS])

  # By default we merely enable some of the most common compiler
  # warnings, but we can turn on as many warnings as we avoid triggering
  # (for library code only, not contrib or external code) by configuring
  # with --enable-paranoid-warnings
  AC_ARG_ENABLE(paranoid-warnings,
                AS_HELP_STRING([--enable-paranoid-warnings],
                               [Turn on paranoid compiler warnings]),
                [AS_CASE("${enableval}",
                         [yes], [acsm_enableparanoid=yes],
                         [no],  [acsm_enableparanoid=no],
                         [AC_MSG_ERROR(bad value ${enableval} for --enable-paranoid-warnings)])],
                [acsm_enableparanoid=no])

  dnl Test paranoid warning flags with -Werror on so we can detect if
  dnl some are unrecognized
  ACSM_ANY_PARANOID_FLAGS=$ACSM_PARANOID_FLAGS
  AS_IF([test "x$acsm_enableparanoid" != "xyes"],
          [ACSM_ANY_PARANOID_FLAGS=''
           AC_MSG_RESULT(<<< Disabling extra paranoid compiler warnings >>>)],
          [old_CXXFLAGS="$CXXFLAGS"
           CXXFLAGS="$CXXFLAGS $WERROR_FLAGS $PARANOID_FLAGS"
           AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
            [AC_MSG_RESULT(<<< Enabled extra paranoid compiler warnings >>>)],
            [ACSM_ANY_PARANOID_FLAGS=''
             AC_MSG_RESULT(<<< Compiler may not support all of $PARANOID_FLAGS >>>)
             AC_MSG_RESULT(<<< Disabling extra paranoid compiler warnings >>>)])
           CXXFLAGS="$old_CXXFLAGS"])
  AC_SUBST(ACSM_ANY_PARANOID_FLAGS)
])

