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
  AC_MSG_CHECKING([for usable C++17 execution policies])
  AC_COMPILE_IFELSE(
    [AC_LANG_PROGRAM([[
      #include <algorithm>
      #include <execution>
      #include <type_traits>
      #include <vector>
      #if !defined(__cpp_lib_execution) || __cpp_lib_execution < 201603L
      #error C++17 execution policies are not supported
      #endif
    ]], [[
      std::vector<double> v(4);
      static_assert(std::is_execution_policy_v<std::decay_t<decltype(std::execution::seq)>>,
                    "std::execution::seq is not an execution policy");
      std::fill(std::execution::seq, v.begin(), v.end(), 1.0);
    ]])],
    [
      AC_MSG_RESULT([yes])
      acsm_have_cxx_execution_policies=yes
      AC_DEFINE(HAVE_CXX_EXECUTION_POLICIES, 1,
                [Flag indicating whether the C++ standard library provides usable execution policies])
    ],
    [
      AC_MSG_RESULT([no])
      acsm_have_cxx_execution_policies=no
    ])
  AC_LANG_POP([C++])
])
