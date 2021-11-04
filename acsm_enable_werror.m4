dnl -------------------------------------------------------------
dnl Enable paranoid compiler warnings if requested
dnl
dnl Usage: ACSM_ENABLE_PARANOID
dnl
dnl -------------------------------------------------------------

AC_DEFUN([ACSM_ENABLE_PARANOID],
[
  AC_REQUIRE([ACSM_SET_CXX_FLAGS])

  # By default we merely enable some warnings, but we can turn those
  # into errors (for library code only, not contrib or external code)
  # by configuring with --enable-werror
  AC_ARG_ENABLE(werror,
                AC_HELP_STRING([--enable-werror],
                               [Turn compilation warnings into errors]),
                [AS_CASE("${enableval}",
                         [yes], [enablewerror=yes],
                         [no],  [enablewerror=no],
                         [AC_MSG_ERROR(bad value ${enableval} for --enable-werror)])],
                [enablewerror=no])

  ANY_WERROR_FLAG=$WERROR_FLAGS
  AS_IF([test "x$enablewerror" != "xyes"],
          [ANY_WERROR_FLAG=''
           AC_MSG_RESULT(<<< Compiler warnings are just warnings >>>)],
          [AX_CHECK_COMPILE_FLAG($WERROR_FLAGS,
            [AC_MSG_RESULT(<<< Compiler warnings are now errors >>>)],
            [ANY_WERROR_FLAG=''
             AC_MSG_RESULT(<<< Compiler does not support $WERROR_FLAGS >>>)
             AC_MSG_RESULT(<<< Compiler warnings are just warnings >>>)])])
  AC_SUBST(ANY_WERROR_FLAG)
])
