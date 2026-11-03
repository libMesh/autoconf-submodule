dnl -------------------------------------------------------------
dnl Check whether the C++ standard library provides usable
dnl execution policies from <execution>.
dnl
dnl Usage: ACSM_CXX_EXECUTION_POLICIES
dnl
dnl Some standard libraries advertise __cpp_lib_execution even when
dnl <execution> cannot be included in the current environment; e.g.
dnl libstdc++ 9 requires TBB to be installed, and libstdc++ 10 fails
dnl when it finds oneTBB rather than legacy TBB headers.  This macro
dnl therefore compiles a test program instead of trusting the feature
dnl macro alone.  Only the sequential policy is exercised, so a
dnl passing test does not imply that a parallel backend can be linked.
dnl
dnl Defines HAVE_CXX_EXECUTION_POLICIES and sets
dnl acsm_have_cxx_execution_policies to yes or no.
dnl
dnl Call this after ACSM_CXX_COMPILER_STANDARD, so that the test
dnl uses the selected C++ standard.
dnl -------------------------------------------------------------
AC_DEFUN([ACSM_CXX_EXECUTION_POLICIES],
[
  AC_LANG_PUSH([C++])

  SAVE_CXXFLAGS="$CXXFLAGS"
  SAVE_LIBS="$LIBS"

  # Force -O0 since dependencies there can get removed by optimizers
  CXXFLAGS="$CXXFLAGS -O0"

  acsm_have_cxx_execution_policies=no
  EXECUTION_LIBS=""

  m4_define([ACSM_EXECUTION_TEST_SRC],
    [AC_LANG_PROGRAM([[
      #include <algorithm>
      #include <execution>
      #include <vector>
      #if !defined(__cpp_lib_execution) || __cpp_lib_execution < 201603L
      #error C++17 execution policies are not supported
      #endif
    ]], [[
      std::vector<double> v(4);
      static_assert(std::is_execution_policy_v<std::decay_t<decltype(std::execution::par)>>,
                    "std::execution::par is not an execution policy");
      std::fill(std::execution::par, v.begin(), v.end(), 1.0);
    ]])])

  AC_MSG_CHECKING([for usable C++17 execution policies without extra libraries])
  AC_LINK_IFELSE([ACSM_EXECUTION_TEST_SRC],
    [
      AC_MSG_RESULT([yes])
      acsm_have_cxx_execution_policies=yes
    ],
    [
      AC_MSG_RESULT([no])
      AC_MSG_CHECKING([for usable C++17 execution policies with TBB])
      LIBS="$LIBS -ltbb"
      AC_LINK_IFELSE([ACSM_EXECUTION_TEST_SRC],
        [
          AC_MSG_RESULT([yes])
          acsm_have_cxx_execution_policies=yes
          EXECUTION_LIBS="-ltbb"
        ],
        [
          AC_MSG_RESULT([no])
        ])
    ])

  CXXFLAGS="$SAVE_CXXFLAGS"
  LIBS="$SAVE_LIBS"

  AC_LANG_POP([C++])

  AS_IF([test x"$acsm_have_cxx_execution_policies" = xyes],
        [
          AC_DEFINE(HAVE_CXX_EXECUTION_POLICIES, 1,
                    [Flag indicating whether the C++ standard library provides usable execution policies])
        ])

  AC_SUBST(EXECUTION_LIBS)
])
