
dnl -------------------------------------------------------------
dnl Determine the C++ compiler in use. Return the name and possibly
dnl version of this compiler in ACSM_GXX_VERSION.
dnl
dnl Usage: ACSM_DETERMINE_CXX_BRAND
dnl
dnl -------------------------------------------------------------
AC_DEFUN([ACSM_DETERMINE_CXX_BRAND],
[
  dnl Set this flag once the compiler "brand" has been detected to skip remaining tests.
  compiler_brand_detected=no

  dnl First check for gcc version, prevents intel's icc from
  dnl pretending to be gcc
  ACSM_REAL_GXX=`($CXX -v 2>&1) | grep "gcc version"`

  dnl Do not allow Intel to masquerade as a "real" GCC.
  is_intel_icc="`($CXX -V 2>&1) | grep 'Intel(R)' | grep 'Compiler'`"
  AS_IF([test "x$is_intel_icc" != "x"],
        [ACSM_REAL_GXX=""])

  AS_IF([test "$GXX" = "yes" && test "x$ACSM_REAL_GXX" != "x"],
        [
          dnl find out the right version
          ACSM_GXX_VERSION_STRING=`($CXX -v 2>&1) | grep "gcc version"`

          AS_CASE("$ACSM_GXX_VERSION_STRING",
                  [*gcc\ version\ 11.*], [AC_MSG_RESULT(<<< C++ compiler is gcc-11.x >>>)
                                         ACSM_GXX_VERSION=gcc11],
                  [*gcc\ version\ 10.*], [AC_MSG_RESULT(<<< C++ compiler is gcc-10.x >>>)
                                         ACSM_GXX_VERSION=gcc10],
                  [*gcc\ version\ 9.*], [AC_MSG_RESULT(<<< C++ compiler is gcc-9.x >>>)
                                         ACSM_GXX_VERSION=gcc9],
                  [*gcc\ version\ 8.*], [AC_MSG_RESULT(<<< C++ compiler is gcc-8.x >>>)
                                         ACSM_GXX_VERSION=gcc8],
                  [*gcc\ version\ 7.*], [AC_MSG_RESULT(<<< C++ compiler is gcc-7.x >>>)
                                         ACSM_GXX_VERSION=gcc7],
                  [*gcc\ version\ 6.*], [AC_MSG_RESULT(<<< C++ compiler is gcc-6.x >>>)
                                         ACSM_GXX_VERSION=gcc6],
                  [*gcc\ version\ 5.*], [AC_MSG_RESULT(<<< C++ compiler is gcc-5.x >>>)
                                         ACSM_GXX_VERSION=gcc5],
                  [*4.9.*], [AC_MSG_RESULT(<<< C++ compiler is gcc-4.9 >>>)
                             ACSM_GXX_VERSION=gcc4.9],
                  [*4.8.*], [AC_MSG_RESULT(<<< C++ compiler is gcc-4.8 >>>)
                             ACSM_GXX_VERSION=gcc4.8],
                  [*4.7.*], [AC_MSG_RESULT(<<< C++ compiler is gcc-4.7 >>>)
                             ACSM_GXX_VERSION=gcc4.7],
                  [*4.6.*], [AC_MSG_RESULT(<<< C++ compiler is gcc-4.6 >>>)
                             ACSM_GXX_VERSION=gcc4.6],
                  [AC_MSG_RESULT(<<< C++ compiler is unknown but accepted gcc version >>>)
                   ACSM_GXX_VERSION=gcc-other])

          dnl Detection was successful, so set the flag.
          compiler_brand_detected=yes
        ])

  dnl Clang/LLVM C++?
  AS_IF([test "x$compiler_brand_detected" = "xno"],
        [
          ACSM_CLANG_VERSION_STRING="`($CXX --version 2>&1)`"
          is_clang="`echo $ACSM_CLANG_VERSION_STRING | grep 'clang'`"

          AS_IF([test "x$is_clang" != "x"],
                [
                  dnl Detect if clang is the version built by
                  dnl Apple, because then the version number means
                  dnl something different...
                  is_apple_clang="`echo $ACSM_CLANG_VERSION_STRING | grep 'Apple'`"
                  clang_vendor="clang"
                  AS_IF([test "x$is_apple_clang" != "x"],
                        [clang_vendor="Apple clang"])

                  AS_CASE("x$ACSM_CLANG_VERSION_STRING",
                          [*clang\ version\ 20.*], [AC_MSG_RESULT(<<< C++ compiler is clang-20.x >>>)
                                                    ACSM_CLANG_VERSION=20],
                          [*clang\ version\ 19.*], [AC_MSG_RESULT(<<< C++ compiler is clang-19.x >>>)
                                                    ACSM_CLANG_VERSION=19],
                          [*clang\ version\ 18.*], [AC_MSG_RESULT(<<< C++ compiler is clang-18.x >>>)
                                                    ACSM_CLANG_VERSION=18],
                          [*clang\ version\ 17.*], [AC_MSG_RESULT(<<< C++ compiler is clang-17.x >>>)
                                                    ACSM_CLANG_VERSION=17],
                          [*clang\ version\ 16.*], [AC_MSG_RESULT(<<< C++ compiler is clang-16.x >>>)
                                                    ACSM_CLANG_VERSION=16],
                          [*clang\ version\ 15.*], [AC_MSG_RESULT(<<< C++ compiler is clang-15.x >>>)
                                                    ACSM_CLANG_VERSION=15],
                          [*clang\ version\ 14.*], [AC_MSG_RESULT(<<< C++ compiler is clang-14.x >>>)
                                                    ACSM_CLANG_VERSION=14],
                          [*clang\ version\ 13.*], [AC_MSG_RESULT(<<< C++ compiler is clang-13.x >>>)
                                                    ACSM_CLANG_VERSION=13],
                          [*clang\ version\ 12.*], [AC_MSG_RESULT(<<< C++ compiler is clang-12.x >>>)
                                                    ACSM_CLANG_VERSION=12],
                          [*clang\ version\ 11.*], [AC_MSG_RESULT(<<< C++ compiler is clang-11.x >>>)
                                                    ACSM_CLANG_VERSION=11],
                          [*clang\ version\ 10.*], [AC_MSG_RESULT(<<< C++ compiler is clang-10.x >>>)
                                                    ACSM_CLANG_VERSION=10],
                          [*clang\ version\ 9.*], [AC_MSG_RESULT(<<< C++ compiler is clang-9.x >>>)
                                                   ACSM_CLANG_VERSION=9],
                          [*clang\ version\ 8.*], [AC_MSG_RESULT(<<< C++ compiler is clang-8.x >>>)
                                                   ACSM_CLANG_VERSION=8],
                          [*clang\ version\ 7.*], [AC_MSG_RESULT(<<< C++ compiler is clang-7.x >>>)
                                                   ACSM_CLANG_VERSION=7],
                          [AC_MSG_RESULT(<<< C++ compiler "$ACSM_CLANG_VERSION" is unknown but accepted clang version >>>)
                           ACSM_CLANG_VERSION=other])

                  ACSM_GXX_VERSION=clang
                  compiler_brand_detected=yes
                ])
        ])

  dnl Intel's ICC/ICX C++ compiler?
  AS_IF([test "x$compiler_brand_detected" = "xno"],
        [
          is_intel_icc="`($CXX -V 2>&1) | grep 'Intel(R)' | grep 'Compiler' | grep -v 'oneAPI'`"
          AS_IF([test "x$is_intel_icc" != "x"],
                [
                  ACSM_GXX_VERSION_STRING="`($CXX -V 2>&1) | grep 'Version '`"
                  AS_CASE("$ACSM_GXX_VERSION_STRING",
                  [*21.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icc 21 >>>)
                            ACSM_GXX_VERSION=intel_icc_v21.x],
                  [*20.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icc 20 >>>)
                            ACSM_GXX_VERSION=intel_icc_v20.x],
                  [*19.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icc 19 >>>)
                            ACSM_GXX_VERSION=intel_icc_v19.x],
                  [*18.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icc 18 >>>)
                            ACSM_GXX_VERSION=intel_icc_v18.x],
                  [*17.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icc 17 >>>)
                            ACSM_GXX_VERSION=intel_icc_v17.x],
                  [*16.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icc 16 >>>)
                            ACSM_GXX_VERSION=intel_icc_v16.x],
                  [*15.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icc 15 >>>)
                            ACSM_GXX_VERSION=intel_icc_v15.x],
                  [*14.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icc 14 >>>)
                            ACSM_GXX_VERSION=intel_icc_v14.x],
                  [*13.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icc 13 >>>)
                            ACSM_GXX_VERSION=intel_icc_v13.x],
                  [AC_MSG_ERROR(Unsupported Intel compiler detected)])
                  compiler_brand_detected=yes
                ])

          is_intel_icx="`($CXX -V 2>&1) | grep 'Intel(R)' | grep 'Compiler' | grep 'oneAPI'`"
          AS_IF([test "x$is_intel_icx" != "x"],
                [
                  ACSM_GXX_VERSION_STRING="`($CXX -V 2>&1) | grep 'Version '`"
                  AS_CASE("$ACSM_GXX_VERSION_STRING",
                  [*25.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icx 25 >>>)
                            ACSM_GXX_VERSION=intel_icx_v25.x],
                  [*24.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icx 24 >>>)
                            ACSM_GXX_VERSION=intel_icx_v24.x],
                  [*23.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icx 23 >>>)
                            ACSM_GXX_VERSION=intel_icx_v23.x],
                  [*22.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icx 22 >>>)
                            ACSM_GXX_VERSION=intel_icx_v22.x],
                  [*21.*], [AC_MSG_RESULT(<<< C++ compiler is Intel(R) icx 21 >>>)
                            ACSM_GXX_VERSION=intel_icx_v21.x],
                  [AC_MSG_ERROR(Unsupported Intel compiler detected)])
                  compiler_brand_detected=yes
                ])
        ])

  dnl Check for IBM xlC. Depending on environment
  dnl variables, moon position, and other reasons unknown to me, this
  dnl compiler can display different names in the first line of output, so
  dnl check various possibilities.  Calling xlC with no arguments displays
  dnl the man page.  Grepping for case-sensitive xlc is not enough if the
  dnl user wants xlC, so we use case-insensitive grep instead.
  AS_IF([test "x$compiler_brand_detected" = "xno"],
        [
          is_ibm_xlc="`($CXX 2>&1) | egrep -i 'xlc'`"
          AS_IF([test "x$is_ibm_xlc" != "x"],
                [
                  AC_MSG_RESULT(<<< C++ compiler is IBM xlC >>>)
                  ACSM_GXX_VERSION=ibm_xlc
                  compiler_brand_detected=yes
                ])
        ])

  dnl Cray C++?
  AS_IF([test "x$compiler_brand_detected" = "xno"],
        [
          is_cray_cc="`($CXX -V 2>&1) | grep 'Cray '`"
          AS_IF([test "x$is_cray_cc" != "x"],
                [
                  AC_MSG_RESULT(<<< C++ compiler is Cray C++ >>>)
                  ACSM_GXX_VERSION=cray_cc
                  compiler_brand_detected=yes
                ])
        ])

  dnl Nvidia C++?
  AS_IF([test "x$compiler_brand_detected" = "xno"],
        [
          is_nvcc="`($CXX -V 2>&1) | grep 'NVIDIA'`"
          AS_IF([test "x$is_nvcc" != "x"],
          [
            AC_MSG_RESULT(<<< C++ compiler is NVIDIA C++ >>>)
            ACSM_GXX_VERSION=nvidia
            compiler_brand_detected=yes
          ])
        ])

  dnl Portland Group C++?
  AS_IF([test "x$compiler_brand_detected" = "xno"],
        [
          is_pgcc="`($CXX -V 2>&1) | grep 'Portland Group\|PGI'`"
          AS_IF([test "x$is_pgcc" != "x"],
          [
            AC_MSG_RESULT(<<< C++ compiler is Portland Group C++ >>>)
            ACSM_GXX_VERSION=portland_group
            compiler_brand_detected=yes
          ])
        ])

  dnl Could not recognize the compiler. Warn the user and continue.
  AS_IF([test "x$compiler_brand_detected" = "xno"],
        [
          AC_MSG_RESULT( WARNING:)
          AC_MSG_RESULT( >>> Unrecognized compiler: "$CXX" <<<)
          AC_MSG_RESULT( You will likely need to modify)
          AC_MSG_RESULT( Make.common directly to specify)
          AC_MSG_RESULT( proper compiler flags)
          ACSM_GXX_VERSION=unknown
        ])
])





# -------------------------------------------------------------
# Set C++ compiler flags to their default values. They will be
# modified according to other options in later steps of
# configuration
#
# ACSM_CXXFLAGS_OPT    : flags for optimized mode
# ACSM_CXXFLAGS_DEVEL  : flags for development mode
# ACSM_CXXFLAGS_DBG    : flags for debug mode
# ACSM_CPPFLAGS_OPT    : preprocessor flags for optimized mode
# ACSM_CPPFLAGS_DEVEL  : preprocessor flags for development mode
# ACSM_CPPFLAGS_DBG    : preprocessor flags for debug mode
#
# ACSM_ASSEMBLY_FLAGS  : flag(s) to enable assembly language output
# ACSM_FPE_SAFETY_FLAGS: flag(s) to disable FPE-emitting optimizations
# ACSM_NODEPRECATEDFLAG: flag(s) to turn off deprecated code warnings
# ACSM_OPROFILE_FLAGS  : flag(s) to enable profiling with oprof/perf
# ACSM_PARANOID_FLAGS  : flags to turn on many more compiler warnings
# ACSM_PROFILING_FLAGS : flag(s) to enable code profiling
# ACSM_RPATHFLAG       : flag(s) to add directories to dll search path
# ACSM_SANITIZE_LDFLAGS: flag(s) for linking with sanitize options
# ACSM_SANITIZE_*_FLAGS: flag(s) for sanitizing or not in each METHOD
# ACSM_WERROR_FLAGS    : flag(s) to turn compiler warnings into errors
# ACSM_XDR_LIBS        : flag(s) to link in Xdr support
#
# Usage: ACSM_SET_CXX_FLAGS
#
# (Note the CXXFLAGS and the CPPFLAGS used for further tests may
#  be augmented)
# -------------------------------------------------------------
AC_DEFUN([ACSM_SET_CXX_FLAGS],
[
  AC_REQUIRE([ACSM_DETERMINE_CXX_BRAND])

  # method-specific preprocessor flags, independent of compiler.
  ACSM_CPPFLAGS_OPT="-DNDEBUG"
  ACSM_CPPFLAGS_DBG="-DDEBUG"
  ACSM_CPPFLAGS_DEVEL=""

  # Flag to add directories to the dynamic library search path; can
  # be changed at a later stage
  ACSM_RPATHFLAG="-Wl,-rpath,"
  ACSM_XDR_LIBS=""

  # Flag for profiling mode; can be modified at a later stage
  ACSM_PROFILING_FLAGS="-pg"

  # Flag for assembly-output mode; can be modified at a later stage
  ACSM_ASSEMBLY_FLAGS="-S"

  # Flag to turn warnings into errors; can be modified at a later stage
  ACSM_WERROR_FLAGS="-Werror"

  # Flags to add every additional warning we expect the library itself
  # to not trigger
  #
  # These can be fairly compiler-specific so the default is blank: we
  # only add warnings within specific compiler version tests.
  ACSM_PARANOID_FLAGS=""

  # The -g flag is necessary for OProfile to produce annotations
  # -fno-omit-frame-pointer flag turns off an optimization that
  # interferes with OProfile callgraphs
  ACSM_OPROFILE_FLAGS="-g -fno-omit-frame-pointer"

  # Turning on floating-point exceptions is technically undefined
  # behavior, and optimizers are starting to take advantage of that.
  # See e.g. LLVM github issue #71492: "Whether your source code
  # contains operations that produce a division by zero is irrelevant,
  # as they may be legally introduced by the compiler." So if we might
  # want to be able to trigger SIGFPE without false positives, we need
  # to use compiler flags that enable that.
  #
  # Those are likely to vary from compiler to compiler, because "just
  # never let the optimizer cause a floating-point exception" used to
  # be a popular enough strategy that you didn't need a compiler
  # flag.  The gcc manual for -fno-trapping-math still says "This
  # option should never be turned on by any -O option since it can
  # result in incorrect output for programs which depend on an exact
  # implementation of IEEE or ISO rules/specifications for math
  # functions"...
  ACSM_FPE_SAFETY_FLAGS=""

  # For compilers that support it (clang >= 3.5.0 and GCC >= 4.8) the
  # user can selectively enable "sanitize" flags for different METHODs
  # with e.g.
  #
  # --enable-sanitize="dbg opt"
  #
  # These flags generally slow down code execution, so you don't
  # necessarily want to turn them on all the time or in all METHODs.

  # Declaring something AC_ARG_VAR does several things, see
  # http://www.gnu.org/software/autoconf/manual/autoconf-2.60/html_node/Setting-Output-Variables.html
  # for more information... not sure we need it in this case.
  # AC_ARG_VAR([SANITIZE_METHODS], [methods we apply sanitizer flags to, e.g. "opt dbg devel"])

  AC_ARG_ENABLE([sanitize],
              AS_HELP_STRING([--enable-sanitize="opt dbg devel prof oprof"],
                             [turn on sanitizer flags for the given methods]),
              [for method in ${enableval} ; do
                 dnl make sure each method specified makes sense
                 AS_CASE("${method}",
                         [optimized|opt|debug|dbg|devel|profiling|pro|prof|oprofile|oprof], [],
                         [AC_MSG_ERROR(bad value ${method} for --enable-sanitize)])
               done
               dnl If we made it here, the case statement didn't detect any errors
               SANITIZE_METHODS=${enableval}],
               [])

  AS_IF([test "x$SANITIZE_METHODS" != x],
        [
          AC_MSG_RESULT([<<< Testing sanitizer flags for method(s) "$SANITIZE_METHODS" >>>])

          dnl Both Clang and GCC docs suggest using "-fsanitize=address -fno-omit-frame-pointer".
          dnl The Clang documentation further suggests using "-O1 -g -fno-optimize-sibling-calls".
          dnl Since these flags also work in GCC, we'll use them there as well...
          COMMON_SANITIZE_OPTIONS="-fsanitize=address -fno-omit-frame-pointer -O1 -g -fno-optimize-sibling-calls"

          dnl Test the sanitizer flags.  Currently Clang and GCC are the only
          dnl compilers that support the address sanitizer, and they use the
          dnl same set of flags.  If the set of flags used by Clang and GCC ever
          dnl diverges, we'll need to set up separate flags and test them in the
          dnl case blocks below...  The ACSM_TEST_SANITIZE_FLAGS function sets
          dnl the variable have_address_sanitizer to either "no" or "yes"
          ACSM_TEST_SANITIZE_FLAGS([$COMMON_SANITIZE_OPTIONS])

          dnl Enable the address sanitizer stuff if the test code compiled
          AS_IF([test "x$have_address_sanitizer" = xyes],
                [
                  dnl As of clang 3.9.0 or so, we also need to pass the sanitize flag to the linker
                  dnl if it is being used during compiling. It seems that we do not need to pass all
                  dnl the flags above, just the sanitize flag itself.
                  ACSM_SANITIZE_LDFLAGS="-Wc,-fsanitize=address"

                  for method in ${SANITIZE_METHODS}; do
                      AS_CASE("${method}",
                              [optimized|opt],      [ACSM_SANITIZE_OPT_FLAGS=$COMMON_SANITIZE_OPTIONS],
                              [debug|dbg],          [ACSM_SANITIZE_DBG_FLAGS=$COMMON_SANITIZE_OPTIONS],
                              [devel],              [ACSM_SANITIZE_DEVEL_FLAGS=$COMMON_SANITIZE_OPTIONS],
                              [profiling|pro|prof], [ACSM_SANITIZE_PROF_FLAGS=$COMMON_SANITIZE_OPTIONS],
                              [oprofile|oprof],     [ACSM_SANITIZE_OPROF_FLAGS=$COMMON_SANITIZE_OPTIONS],
                              [AC_MSG_ERROR(bad value ${method} for --enable-sanitize)])
                  done
                ])
        ])

  # First the flags for gcc compilers
  AS_IF([test "$GXX" = "yes" && test "x$ACSM_REAL_GXX" != "x"],
        [
          ACSM_CXXFLAGS_OPT="$ACSM_CXXFLAGS_OPT -O2 -felide-constructors -fstrict-aliasing -Wdisabled-optimization"
          dnl devel flags are added on two lines since there are so many
          ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DEVEL -O2 -felide-constructors -g -pedantic -W -Wall -Wextra -Wno-long-long -Wunused"
          ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DEVEL -Wpointer-arith -Wformat -Wparentheses -Wuninitialized -fstrict-aliasing -Woverloaded-virtual -Wdisabled-optimization"
          ACSM_CXXFLAGS_DBG="$ACSM_CXXFLAGS_DBG -O0 -felide-constructors -g -pedantic -W -Wall -Wextra -Wno-long-long -Wunused -Wpointer-arith -Wformat -Wparentheses -Woverloaded-virtual"
          ACSM_NODEPRECATEDFLAG="-Wno-deprecated"

          dnl this is the default on current gcc but let's be safe
          ACSM_FPE_SAFETY_FLAGS="-ftrapping-math"

          ACSM_CFLAGS_OPT="-O2 -fstrict-aliasing"
          ACSM_CFLAGS_DEVEL="$ACSM_CFLAGS_OPT -g -Wimplicit -fstrict-aliasing"
          ACSM_CFLAGS_DBG="-O0 -g -Wimplicit"
          ACSM_ASSEMBLY_FLAGS="$ACSM_ASSEMBLY_FLAGS -fverbose-asm"

          dnl Workaround for Ubuntu bug 1953401 (and likely other gcc 11 too)
          AS_IF([test "x$ACSM_GXX_VERSION" != "xgcc11"],
                [
                  ACSM_CXXFLAGS_OPT="$ACSM_CXXFLAGS_OPT -funroll-loops"
                  ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DEVEL -funroll-loops"
                  ACSM_CFLAGS_OPT="$ACSM_CFLAGS_OPT -funroll-loops"
                  ACSM_CFLAGS_DEVEL="$ACSM_CFLAGS_DEVEL -funroll-loops"
                ])

          dnl Tested on gcc 4.8.5; hopefully the other 4.8.x and all
          dnl later versions support these too:
          ACSM_PARANOID_FLAGS="-Wall -Wextra -Wcast-align -Wcast-qual -Wdisabled-optimization -Wformat=2"
          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wformat-nonliteral -Wformat-security -Wformat-y2k"
          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Winvalid-pch -Wlogical-op -Wmissing-field-initializers"
          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wmissing-include-dirs -Wpacked -Wredundant-decls"
          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wshadow -Wstack-protector -Wstrict-aliasing -Wswitch-default"
          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wtrigraphs -Wunreachable-code -Wunused-label"
          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wunused-parameter -Wunused-value -Wvariadic-macros"
          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wvolatile-register-var -Wwrite-strings"

          AS_IF([test "x$acsm_enableglibcxxdebugging" = "xyes"],
                [AC_MSG_RESULT(<<< Adding GLIBCXX debugging flags >>>)
                 ACSM_CPPFLAGS_DBG="$ACSM_CPPFLAGS_DBG -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC"])

          # GCC 4.6.3 warns about variadic macros but supports them just
          # fine, so let's turn off that warning.
          AS_CASE("$ACSM_GXX_VERSION",
                  [gcc4.6 | gcc5], [ACSM_CXXFLAGS_OPT="$ACSM_CXXFLAGS_OPT -Wno-variadic-macros"
                                    ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DEVEL -Wno-variadic-macros"
                                    ACSM_CXXFLAGS_DBG="$ACSM_CXXFLAGS_DBG -Wno-variadic-macros"])

          dnl Set OS-specific flags for linkers & other stuff
          dnl For Solaris we need to pass a different flag to the linker for specifying the
          dnl dynamic library search path and add -lrpcsvc to use XDR
          AS_CASE("$target",
                  [*solaris*], [ACSM_RPATHFLAG="-Wl,-R,"
                                ACSM_XDR_LIBS="-lrpcsvc"])
        ],
        [
    dnl Non-gcc compilers
    AS_CASE("$ACSM_GXX_VERSION",
            [ibm_xlc], [
                          ACSM_CXXFLAGS_OPT="-O3 -qmaxmem=-1 -w -qansialias -Q=10 -qrtti=all -qstaticinline"
                          ACSM_CXXFLAGS_DBG="-qmaxmem=-1 -qansialias -qrtti=all -g -qstaticinline"
                          ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DBG"
                          ACSM_NODEPRECATEDFLAG=""
                          ACSM_CFLAGS_OPT="-O3 -qmaxmem=-1 -w -qansialias -Q=10"
                          ACSM_CFLAGS_DBG="-qansialias -g"
                          ACSM_CFLAGS_DEVEL="$ACSM_CFLAGS_DBG"
                        ],

            dnl All Intel ICC/ECC flavors
            [intel_*], [
                          dnl Intel understands the gcc-like no-deprecated flag
                          ACSM_NODEPRECATEDFLAG="-Wno-deprecated"

                          dnl Intel compilers use -qp for profiling
                          ACSM_PROFILING_FLAGS="-qp"

                          dnl Intel options for annotated assembly
                          ACSM_ASSEMBLY_FLAGS="$ACSM_ASSEMBLY_FLAGS -fverbose-asm -fsource-asm"

                          dnl The -g flag is all OProfile needs to produce annotations
                          ACSM_OPROFILE_FLAGS="-g"

                          dnl A dozen or so g++-supported warnings aren't supported on
                          dnl all icpc versions
                          ACSM_PARANOID_FLAGS="-Wall -Wextra -Wdisabled-optimization -Wformat=2"
                          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wformat-security"
                          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Winvalid-pch"
                          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wmissing-include-dirs"
                          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wtrigraphs"
                          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wunused-parameter"
                          ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wwrite-strings"

                          dnl Disable some warning messages on Intel compilers:
                          dnl 161:  unrecognized pragma GCC diagnostic warning "-Wdeprecated-declarations"
                          dnl 175:  subscript out of range
                          dnl       FIN-S application code causes many false
                          dnl       positives with this
                          dnl 266:  function declared implicitly
                          dnl       Metis function "GKfree" caused this error
                          dnl       in almost every file.
                          dnl 488:  template parameter "Scalar1" is not used in declaring the
                          dnl       parameter types of function template
                          dnl       This warning was generated from one of the type_vector.h
                          dnl       constructors that uses some SFINAE tricks.
                          dnl 1476: field uses tail padding of a base class
                          dnl 1505: size of class is affected by tail padding
                          dnl       simply warns of a possible incompatibility with
                          dnl       the g++ ABI for this case
                          dnl 1572: floating-point equality and inequality comparisons are unreliable
                          dnl       Well, duh, when the tested value is computed...  OK when it
                          dnl       was from an assignment.
                          AS_CASE("$ACSM_GXX_VERSION",
                                  [intel_icc_*],
                                  [
                                    ACSM_PROFILING_FLAGS="-p"
                                    ACSM_CXXFLAGS_DBG="$ACSM_CXXFLAGS_DBG -w1 -g -wd175 -wd1476 -wd1505 -wd1572 -wd488 -wd161"
                                    ACSM_CXXFLAGS_OPT="$ACSM_CXXFLAGS_OPT -O3 -unroll -w0 -ftz"
                                    ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DEVEL -w1 -g -wd175 -wd1476 -wd1505 -wd1572 -wd488 -wd161"
                                    ACSM_CFLAGS_DBG="$ACSM_CFLAGS_DBG -w1 -g -wd266 -wd1572 -wd488 -wd161"
                                    ACSM_CFLAGS_OPT="$ACSM_CFLAGS_OPT -O3 -unroll -w0 -ftz"
                                    ACSM_CFLAGS_DEVEL="$ACSM_CFLAGS_DBG"
                                  ],
                                  [intel_icx_*],
                                  [
                                    ACSM_PROFILING_FLAGS=""
                                    ACSM_CXXFLAGS_DBG="$ACSM_CXXFLAGS_DBG -O0 -g"
                                    ACSM_CXXFLAGS_OPT="$ACSM_CXXFLAGS_OPT -O3"
                                    ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DEVEL -O2 -g"
                                    ACSM_CFLAGS_DBG="$ACSM_CFLAGS_DBG -O0 -g"
                                    ACSM_CFLAGS_OPT="$ACSM_CFLAGS_OPT -O3"
                                    ACSM_CFLAGS_DEVEL="$ACSM_CFLAGS_DEVEL -O2 -g"
                                  ],
                                  [AC_MSG_RESULT(Unknown Intel compiler "$ACSM_GXX_VERSION")])
                          dnl icx >= 24.x accepts -fopenmp but prefers -qopenmp, issuing a warning
                          dnl with the former. The following causes compilation to fail with
                          dnl -fopenmp at configuration time, thereby forcing -qopenmp.
                          AS_CASE("$ACSM_GXX_VERSION",
                                  [intel_icx_v21.x | intel_icx_v22.x | intel_icx_v23.x],
                                  [],
                                  [
                                    CXXFLAGS="$CXXFLAGS -Werror=recommended-option"
                                    CFLAGS="$CFLAGS -Werror=recommended-option"
                                  ])
                       ],

            [nvidia], [
                          dnl Disable some warning messages on NVIDIA compilers:
                          dnl 11:   unrecognized preprocessing directive
                          dnl       "#warning".  It doesn't recognize "#warning".
                          dnl 111:  statement is unreachable
                          dnl       We have a ton of return-statement-after-error-thrown code
                          dnl       specifically to keep *other* compilers' warnings happy
                          dnl 177:  declared but never referenced
                          dnl       This hurts to disable, but NVIDIA doesn't understand RAII!  It
                          dnl       complains about scoped locks!  About factory patterns!
                          dnl       Need to suppress this after -Wunused or that overrides it.
                          dnl 445:  template parameter "Scalar1" is not used in declaring the
                          dnl       parameter types of function template
                          dnl       This warning was generated from one of the type_vector.h
                          dnl       constructors that uses some SFINAE tricks.
                          dnl 1676: unrecognized GCC pragma
                          dnl       petscconf_poison.h screams about this

                          dnl --display_error_number is really useful when we need a pragma to disable
                          dnl a newly-cropped-up overzealous error...
                                ACSM_CXXFLAGS_DBG="$ACSM_CXXFLAGS_DBG -O0 --display_error_number -g -pedantic -Wno-long-long -Wunused -Wuninitialized --diag_suppress=11,111,177,445,1676"
                                ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DEVEL -O2 --display_error_number -g -pedantic -Wno-long-long -Wunused -Wuninitialized --diag_suppress=11,111,177,445,1676"
                                ACSM_CXXFLAGS_OPT="$ACSM_CXXFLAGS_OPT -O2 --display_error_number --diag_suppress=11,111,177,445,1676"

                                ACSM_NODEPRECATEDFLAG="-Wno-deprecated-declarations"

                                dnl Having to include -Mnovect is horrifying, but -Kieee alone still
                                dnl gives me an FPE from pow(0,1) on NVidia HPC SDK 24.7
                                ACSM_FPE_SAFETY_FLAGS="-Kieee -Mnovect"

                                ACSM_CFLAGS_DBG="$ACSM_CFLAGS_DBG -O0 -g"
                                ACSM_CFLAGS_DEVEL="$ACSM_CFLAGS_DEVEL -O2 -g"
                                ACSM_CFLAGS_OPT="$ACSM_CFLAGS_OPT -O2"

                                dnl Disable exception handling if we dont use it
                                AS_IF([test "$enableexceptions" = no],
                                      [
                                        ACSM_CXXFLAGS_DBG="$ACSM_CXXFLAGS_DBG --no_exceptions"
                                        ACSM_CXXFLAGS_OPT="$ACSM_CXXFLAGS_OPT --no_exceptions"
                                      ])
                              ],

            [portland_group], [
                                ACSM_CXXFLAGS_DBG="$ACSM_CXXFLAGS_DBG -g --no_using_std"
                                ACSM_CXXFLAGS_OPT="$ACSM_CXXFLAGS_OPT -O2 --no_using_std -fast -Minform=severe"
                                ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DBG"

                                dnl PG C++ definitely doesnt understand -Wno-deprecated...
                                ACSM_NODEPRECATEDFLAG=""

                                ACSM_CFLAGS_DBG="$ACSM_CFLAGS_DBG -g"
                                ACSM_CFLAGS_OPT="$ACSM_CFLAGS_OPT -O2"
                                ACSM_CFLAGS_DEVEL="$ACSM_CFLAGS_DBG"

                                dnl Disable exception handling if we dont use it
                                AS_IF([test "$enableexceptions" = no],
                                      [
                                        ACSM_CXXFLAGS_DBG="$ACSM_CXXFLAGS_DBG --no_exceptions"
                                        ACSM_CXXFLAGS_OPT="$ACSM_CXXFLAGS_OPT --no_exceptions"
                                      ])
                              ],

            [cray_cc], [
                         ACSM_CXXFLAGS_DBG="-h conform,one_instantiation_per_object,instantiate=used,noimplicitinclude -G n"
                         ACSM_CXXFLAGS_OPT="-h conform,one_instantiation_per_object,instantiate=used,noimplicitinclude -G n"
                         ACSM_CXXFLAGS_DEVEL="-h conform,one_instantiation_per_object,instantiate=used,noimplicitinclude -G n"
                         ACSM_NODEPRECATEDFLAG=""
                         ACSM_CFLAGS_DBG="-G n"
                         ACSM_CFLAGS_OPT="-G n"
                         ACSM_CFLAGS_DEVEL="-G n"
                       ],

            [clang], [
                       ACSM_CXXFLAGS_OPT="$ACSM_CXXFLAGS_OPT -O2 -felide-constructors -Qunused-arguments -Wunused-parameter -Wunused"
                       dnl devel flags are added on two lines since there are so many
                       ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DEVEL -O2 -felide-constructors -g -pedantic -W -Wall -Wextra -Wno-long-long"
                       ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DEVEL -Wunused-parameter -Wunused -Wpointer-arith -Wformat -Wparentheses -Wuninitialized -Qunused-arguments -Woverloaded-virtual -fno-limit-debug-info"
                       dnl dbg flags are added on two lines since there are so many
                       ACSM_CXXFLAGS_DBG="$ACSM_CXXFLAGS_DBG -O0 -felide-constructors -g -pedantic -W -Wall -Wextra -Wno-long-long"
                       ACSM_CXXFLAGS_DBG="$ACSM_CXXFLAGS_DBG -Wunused-parameter -Wunused -Wpointer-arith -Wformat -Wparentheses -Qunused-arguments -Woverloaded-virtual -fno-limit-debug-info"
                       ACSM_NODEPRECATEDFLAG="-Wno-deprecated"

                       dnl -ftrapping-math is only supported with
                       dnl clang 10 and newer.
                       dnl
                       dnl The warning we need to disable with it on
                       dnl ARM Mac is only enabled with clang 12 and
                       dnl newer
                       AS_IF([test "x$ACSM_CLANG_VERSION" = "xother" || test $ACSM_CLANG_VERSION -ge 10],
                             [ACSM_FPE_SAFETY_FLAGS="-ftrapping-math"],
                             [ACSM_FPE_SAFETY_FLAGS=""])

                       AS_IF([test "x$ACSM_CLANG_VERSION" = "xother" || test $ACSM_CLANG_VERSION -ge 12],
                             [ACSM_FPE_SAFETY_FLAGS="$ACSM_FPE_SAFETY_FLAGS -Wno-unsupported-floating-point-opt"])

                       dnl Tested on clang 3.4.2
                       ACSM_PARANOID_FLAGS="-Wall -Wextra -Wcast-align -Wdisabled-optimization -Wformat=2"
                       ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wformat-nonliteral -Wformat-security -Wformat-y2k"
                       ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Winvalid-pch -Wmissing-field-initializers"
                       ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wmissing-include-dirs -Wpacked"
                       ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wstack-protector -Wtrigraphs"
                       ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wunreachable-code -Wunused-label"
                       ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wunused-parameter -Wunused-value -Wvariadic-macros"
                       ACSM_PARANOID_FLAGS="$ACSM_PARANOID_FLAGS -Wvolatile-register-var -Wwrite-strings"

                       ACSM_CFLAGS_OPT="-O2 -Qunused-arguments -Wunused"
                       ACSM_CFLAGS_DEVEL="$ACSM_CFLAGS_OPT -g -Wimplicit -fno-limit-debug-info -Wunused"
                       ACSM_CFLAGS_DBG="-g -Wimplicit -Qunused-arguments -fno-limit-debug-info -Wunused"

                       dnl This argument appears in clang 17 and
                       dnl appears to become necessary to safely
                       dnl dynamic_cast in later clang on OSX
                       AS_IF([test "x$ACSM_CLANG_VERSION" = "xother" || test $ACSM_CLANG_VERSION -ge 17],
                             [
                               ACSM_CXXFLAGS_OPT="$ACSM_CFLAGS_OPT -fno-assume-unique-vtables"
                               ACSM_CXXFLAGS_DEVEL="$ACSM_CFLAGS_DEVEL -fno-assume-unique-vtables"
                               ACSM_CXXFLAGS_DBG="$ACSM_CFLAGS_DBG -fno-assume-unique-vtables"
                             ])
                       AS_IF([test "x$acsm_enableglibcxxdebugging" = "xyes"],
                             [
                              AC_LANG_PUSH([C++])
                              AC_MSG_CHECKING([whether Clang is using libstdc++])
                              AC_COMPILE_IFELSE(
                                [AC_LANG_PROGRAM([[
                                  #include <vector>
                                  #ifndef __GLIBCXX__
                                  #error Not using libstdc++
                                  #endif
                                ]])],
                                [
                                  AC_MSG_RESULT([yes])
                                  clang_uses_libstdcpp=yes
                                ],
                                [
                                  AC_MSG_RESULT([no])
                                  clang_uses_libstdcpp=no
                                ]
                              )
                              AC_LANG_POP([C++])
                              AS_IF([test "x$clang_uses_libstdcpp" = "xyes"],
                                    [AC_MSG_RESULT(<<< Adding GLIBCXX debugging flags >>>)
                                     ACSM_CPPFLAGS_DBG="$ACSM_CPPFLAGS_DBG -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC"])
                             ])

                     ],

            dnl default case
            [
              AC_MSG_RESULT(No specific options for this C++ compiler known)
              ACSM_CXXFLAGS_DBG="$CXXFLAGS"
              ACSM_CXXFLAGS_OPT="$CXXFLAGS"
              ACSM_CXXFLAGS_DEVEL="$CXXFLAGS"
              ACSM_NODEPRECATEDFLAG=""

              ACSM_CFLAGS_DBG="$CFLAGS"
              ACSM_CFLAGS_OPT="$CFLAGS"
              ACSM_CFLAGS_DEVEL="$CFLAGS"
            ])
  ])
])


# -------------------------------------------------------------
# Set compiler flags to their default values. They will be
# modified according to other options in later steps of
# configuration.
#
# This just calls ACSM_SET_CXX_FLAGS, but from a more accurate name;
# here we also set C compiler flags, cpp flags, and the rpath flag for
# linkers.
AC_DEFUN([ACSM_SET_BUILD_FLAGS],
[
  ACSM_SET_CXX_FLAGS
])


# -------------------------------------------------------------
# Add FPE safety flags to compiler flags, unless requested not to by
# the user.

AC_DEFUN([ACSM_SET_FPE_SAFETY_FLAGS],
[
  AC_REQUIRE([ACSM_SET_CXX_FLAGS])

  AC_ARG_ENABLE(fpe-safety,
                [AS_HELP_STRING([--disable-fpe-safety],
                                [remove FPE-trapping compiler flags])],
                [AS_CASE("${enableval}",
                         [yes], [acsm_enablefpesafety=yes],
                         [no],  [acsm_enablefpesafety=no],
                         [AC_MSG_ERROR(bad value ${enableval} for --enable-fpe-safety)])],
                [acsm_enablefpesafety=yes])

  AS_IF([test "$acsm_enablefpesafety" = "yes"],
        [
          AC_LANG_PUSH([C])
          ac_fpe_safety_save_CFLAGS="$CFLAGS"
          CFLAGS="${CFLAGS} ${ACSM_FPE_SAFETY_FLAGS}"
          AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],[])],[],
            [
              AC_MSG_WARN([unable to compile C with FPE safety flag ($CC $ACSM_FPE_SAFETY_FLAGS)])
              ACSM_FPE_SAFETY_FLAGS=""
            ])
          CFLAGS="$ac_fpe_safety_save_CFLAGS"
          AC_LANG_POP([C])

          AC_LANG_PUSH([C++])
          ac_fpe_safety_save_CXXFLAGS="$CXXFLAGS"
          CXXFLAGS="${CXXFLAGS} ${ACSM_FPE_SAFETY_FLAGS}"
          AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],[])],[],
            [
              AC_MSG_WARN([unable to compile C++ with FPE safety flag ($CXX $ACSM_FPE_SAFETY_FLAGS)])
              ACSM_FPE_SAFETY_FLAGS=""
            ])
          CXXFLAGS="$ac_fpe_safety_save_CXXFLAGS"
          AC_LANG_POP([C++])

          AS_IF([test "x$ACSM_FPE_SAFETY_FLAGS" != "x"],
                [
                  AC_MSG_RESULT(<<< Adding $ACSM_FPE_SAFETY_FLAGS for FPE safety >>>)
                ],
                [
                  AC_MSG_RESULT(<<< No flags found to use for FPE safety >>>)
                ])
          ACSM_CXXFLAGS_OPT="$ACSM_CXXFLAGS_OPT $ACSM_FPE_SAFETY_FLAGS"
          ACSM_CXXFLAGS_DBG="$ACSM_CXXFLAGS_DBG $ACSM_FPE_SAFETY_FLAGS"
          ACSM_CXXFLAGS_DEVEL="$ACSM_CXXFLAGS_DEVEL $ACSM_FPE_SAFETY_FLAGS"

          ACSM_CFLAGS_OPT="$ACSM_CFLAGS_OPT $ACSM_FPE_SAFETY_FLAGS"
          ACSM_CFLAGS_DBG="$ACSM_CFLAGS_DBG $ACSM_FPE_SAFETY_FLAGS"
          ACSM_CFLAGS_DEVEL="$ACSM_CFLAGS_DEVEL $ACSM_FPE_SAFETY_FLAGS"
        ],
        [
          AC_MSG_RESULT(<<< Not enabling flags for FPE safety >>>)
        ])
])


AC_DEFUN([ACSM_SET_GLIBCXX_DEBUG_FLAGS],
[
  # in the case blocks below we may add GLIBCXX-specific pedantic debugging preprocessor
  # definitions. Should only be used by a knowing user, because these options break
  # ABI compatibility.
  AC_ARG_ENABLE(glibcxx-debugging,
                [AS_HELP_STRING([--enable-glibcxx-debugging],
                                [enable -D_GLIBCXX_DEBUG -D_GLIBCXX_DEBUG_PEDANTIC in dbg mode])],
                [AS_CASE("${enableval}",
                         [yes], [acsm_enableglibcxxdebugging=yes],
                         [no],  [acsm_enableglibcxxdebugging=no],
                         [AC_MSG_ERROR(bad value ${enableval} for --enable-glibcxx-debugging)])],
                [acsm_enableglibcxxdebugging=no])

  # GLIBCXX debugging causes untold woes on mac machines - so disable it
  AS_IF([test `uname` = "Darwin"],
        [
          AC_MSG_RESULT(<<< Disabling GLIBCXX debugging on Darwin >>>)
          acsm_enableglibcxxdebugging=no
        ])
  AM_CONDITIONAL(ACSM_ENABLE_GLIBCXX_DEBUGGING, test x$acsm_enableglibcxxdebugging = xyes)


  # GLIBCXX-specific debugging flags conflict with cppunit on many of
  # our users' systems.  However, being able to override this allows
  # us to increase our unit test coverage.
  AC_ARG_ENABLE(glibcxx-debugging-cppunit,
                [AS_HELP_STRING([--enable-glibcxx-debugging-cppunit],
                [Use GLIBCXX debugging flags for unit tests])],
                [AS_CASE("${enableval}",
                         [yes], [acsm_enableglibcxxdebuggingcppunit=yes],
                         [no],  [acsm_enableglibcxxdebuggingcppunit=no],
                         [AC_MSG_ERROR(bad value ${enableval} for --enable-glibcxx-debugging-cppunit)])],
                [acsm_enableglibcxxdebuggingcppunit=no])

  AM_CONDITIONAL(ACSM_ENABLE_GLIBCXX_DEBUGGING_CPPUNIT, test x$acsm_enableglibcxxdebuggingcppunit = xyes)
])
