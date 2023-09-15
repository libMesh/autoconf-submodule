dnl -------------------------------------------------------------
dnl Enable paranoid compiler warnings if requested
dnl
dnl Usage: ACSM_ENABLE_WERROR
dnl
dnl -------------------------------------------------------------

AC_DEFUN([ACSM_ENABLE_WERROR],
[
  AC_REQUIRE([ACSM_SET_CXX_FLAGS])

  # By default we merely enable some warnings, but we can turn those
  # into errors (for library code only, not contrib or external code)
  # by configuring with --enable-werror
  AC_ARG_ENABLE(werror,
                AS_HELP_STRING([--enable-werror],
                               [Turn compilation warnings into errors]),
                [AS_CASE("${enableval}",
                         [yes], [acsm_enablewerror=yes],
                         [no],  [acsm_enablewerror=no],
                         [AC_MSG_ERROR(bad value ${enableval} for --enable-werror)])],
                [acsm_enablewerror=no])

  ACSM_ANY_WERROR_FLAG=$WERROR_FLAGS
  AS_IF([test "x$acsm_enablewerror" != "xyes"],
          [ACSM_ANY_WERROR_FLAG=''
           AC_MSG_RESULT(<<< Compiler warnings are just warnings >>>)],
          [AX_CHECK_COMPILE_FLAG($WERROR_FLAGS,
            [AC_MSG_RESULT(<<< Compiler warnings are now errors >>>)],
            [ACSM_ANY_WERROR_FLAG=''
             AC_MSG_RESULT(<<< Compiler does not support $WERROR_FLAGS >>>)
             AC_MSG_RESULT(<<< Compiler warnings are just warnings >>>)])])
  AC_SUBST(ACSM_ANY_WERROR_FLAG)
])
