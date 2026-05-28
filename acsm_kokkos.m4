dnl -------------------------------------------------------------
dnl Kokkos -- optional, enables the native Kokkos FE math path
dnl -------------------------------------------------------------
AC_DEFUN([ACSM_CONFIGURE_KOKKOS],
[
  AC_ARG_VAR([KOKKOS_CXXFLAGS], [Extra C++ flags for compiling Kokkos sources])

  AC_ARG_WITH([kokkos],
    AS_HELP_STRING([--with-kokkos=DIR],
                   [Enable Kokkos support using the installation at DIR]),
    [KOKKOS_DIR="$withval"],
    [KOKKOS_DIR="no"])

   AC_ARG_WITH([kokkos-include],
    AS_HELP_STRING([--with-kokkos-include=DIR],
                   [Enable Kokkos support using the headers in DIR]),
    [KOKKOS_INCLUDE_DIR="$withval"],
    [KOKKOS_INCLUDE_DIR="$KOKKOS_DIR/include"])

   AC_ARG_WITH([kokkos-lib],
    AS_HELP_STRING([--with-kokkos-lib=DIR],
                   [Enable Kokkos support using the libraries in DIR]),
    [KOKKOS_LIB_DIR="$withval"],
    [KOKKOS_LIB_DIR="$KOKKOS_DIR/lib"])

  AC_ARG_WITH([kokkos-backend],
    AS_HELP_STRING([--with-kokkos-backend=BACKEND],
                   [cuda|hip|sycl|openmp|serial (default: auto-detect from KokkosCore_config.h)]),
    [KOKKOS_BACKEND="$withval"], [KOKKOS_BACKEND="auto"])

  dnl Setting --enable-kokkos-required causes an error to be emitted during
  dnl configure if Kokkos is not successfully detected.
  AC_ARG_ENABLE(kokkos-required,
                AS_HELP_STRING([--enable-kokkos-required],
                               [Error if Kokkos is not detected by configure]),
                [AS_CASE("${enableval}",
                         [yes], [kokkosrequired=yes],
                         [no],  [kokkosrequired=no],
                         [AC_MSG_ERROR(bad value ${enableval} for --enable-kokkos-required)])],
                     [kokkosrequired=no])

  dnl Allow the caller (e.g. MOOSE's configure_libmesh.sh) to pre-set the
  dnl Kokkos compiler and flags via environment variables.  If KOKKOS_CXX is
  dnl already set, we skip auto-detection entirely — the caller knows best.
  dnl We use AC_SUBST (not AC_ARG_VAR) so these flags stay scoped to .K
  dnl compilation rules and don't leak into the main CPPFLAGS/CXXFLAGS.

  AS_IF([test "x$KOKKOS_INCLUDE_DIR" != "xno/include" -a "x$KOKKOS_LIB_DIR" != "xno/lib"],
    [
      dnl Set defaults for any variables not provided by caller or auto-detect
      KOKKOS_CPPFLAGS="${KOKKOS_CPPFLAGS:--DACSM_KOKKOS_COMPILATION -I$KOKKOS_INCLUDE_DIR}"
      KOKKOS_LDFLAGS="${KOKKOS_LDFLAGS:--L$KOKKOS_LIB_DIR}"
      KOKKOS_LIBS="${KOKKOS_LIBS:--lkokkoscore}"

      AC_CHECK_FILE([$KOKKOS_INCLUDE_DIR/Kokkos_Core.hpp],
        [
          enablekokkos=yes
          libmesh_optional_INCLUDES="$libmesh_optional_INCLUDES -I$KOKKOS_INCLUDE_DIR"
          libmesh_optional_LIBS="$libmesh_optional_LIBS -L$KOKKOS_LIB_DIR -lkokkoscore"

          dnl Only auto-detect if KOKKOS_CXX was not pre-set by the caller
          AS_IF([test "x$KOKKOS_CXX" = "x"],
            [
              KOKKOS_CFG="$KOKKOS_INCLUDE_DIR/KokkosCore_config.h"

              dnl Auto-detect backend
              AC_PROG_GREP
              AC_PROG_SED

              dnl Check if Kokkos was built with OpenMP
              have_kokkos_openmp=no
              AS_IF([test -r "$KOKKOS_CFG"],
                [AS_IF([grep -F -q '#define KOKKOS_ENABLE_OPENMP' "$KOKKOS_CFG"],
                  [have_kokkos_openmp=yes],
                  [have_kokkos_openmp=no])])

              AS_IF([test "x$KOKKOS_BACKEND" = "xauto"],
                [
                  AS_IF([test -r "$KOKKOS_CFG"],
                    [
                      AS_IF([grep -F -q '#define KOKKOS_ENABLE_CUDA' "$KOKKOS_CFG"],
                        [KOKKOS_BACKEND=cuda],
                        [AS_IF([grep -F -q '#define KOKKOS_ENABLE_HIP' "$KOKKOS_CFG"],
                          [KOKKOS_BACKEND=hip],
                          [AS_IF([grep -F -q '#define KOKKOS_ENABLE_SYCL' "$KOKKOS_CFG"],
                            [KOKKOS_BACKEND=sycl],
                            [AS_IF([test "x$have_kokkos_openmp" = "xyes"],
                              [KOKKOS_BACKEND=openmp],
                              [KOKKOS_BACKEND=serial])])])])
                    ],
                    [KOKKOS_BACKEND=serial])
                ])

              AC_MSG_RESULT([Kokkos backend: $KOKKOS_BACKEND])

              case "$KOKKOS_BACKEND" in
                cuda)
                  AC_PATH_PROG([NVCC],[nvcc],[no],[$PATH])
                  AS_IF([test "x$NVCC" = "xno"],
                    [AC_MSG_ERROR([nvcc not found but Kokkos CUDA backend requested])])
                  KOKKOS_CXX="$NVCC"
                  KOKKOS_CXXFLAGS="--forward-unknown-to-host-compiler -x cu $KOKKOS_CXXFLAGS"
                  KOKKOS_LDFLAGS="--forward-unknown-to-host-compiler $KOKKOS_LDFLAGS"

                  dnl
                  dnl credit to ChatGPT for the ensuing parsing of arch's from kokkos config
                  dnl

                  dnl harvest defined arch macros from Kokkos config
                  AC_MSG_CHECKING([for Kokkos defined architectures])
                  ax_kokkos_arch_lines=`$GREP '^[[[:space:]]]*#define[[:space:]]\{1,\}KOKKOS_ARCH_[A-Za-z0-9_][A-Za-z0-9_]*' "$KOKKOS_CFG" \
                    | $SED -n 's/.*KOKKOS_ARCH_\([[A-Za-z0-9_]][[A-Za-z0-9_]]*\).*/\1/p'`
                  AC_MSG_RESULT([$ax_kokkos_arch_lines])

                  dnl Keep only GPU-ish tokens we know how to map
                  ax_kokkos_arch_gpu=`printf "%s\n" "$ax_kokkos_arch_lines" \
                    | "$GREP" '^\(KEPLER\(30\|32\|35\|37\)\{0,1\}\|MAXWELL\(50\|52\|53\)\{0,1\}\|PASCAL\(60\|61\)\{0,1\}\|VOLTA\(70\|72\)\{0,1\}\|  TURING75\|AMPERE\(80\|86\)\{0,1\}\|ADA89\|HOPPER\(90\)\{0,1\}\|AMD_GFX[0-9A-Za-z]\{1,\}\)$' \
                    || true`

                  dnl Prefer numbered macros; if both generic and numbered exist, numbered will appear too.
                  ax_cuda_sms=
                  for t in $ax_kokkos_arch_gpu; do
                    case "$t" in
                      KEPLER30|KEPLER)  ax_cuda_sms="$ax_cuda_sms 30" ;;
                      KEPLER32)         ax_cuda_sms="$ax_cuda_sms 32" ;;
                      KEPLER35)         ax_cuda_sms="$ax_cuda_sms 35" ;;
                      KEPLER37)         ax_cuda_sms="$ax_cuda_sms 37" ;;
                      MAXWELL|MAXWELL50) ax_cuda_sms="$ax_cuda_sms 50" ;;
                      MAXWELL52)        ax_cuda_sms="$ax_cuda_sms 52" ;;
                      MAXWELL53)        ax_cuda_sms="$ax_cuda_sms 53" ;;
                      PASCAL|PASCAL60)  ax_cuda_sms="$ax_cuda_sms 60" ;;
                      PASCAL61)         ax_cuda_sms="$ax_cuda_sms 61" ;;
                      VOLTA|VOLTA70)    ax_cuda_sms="$ax_cuda_sms 70" ;;
                      VOLTA72)          ax_cuda_sms="$ax_cuda_sms 72" ;;
                      TURING75)         ax_cuda_sms="$ax_cuda_sms 75" ;;
                      AMPERE|AMPERE80)  ax_cuda_sms="$ax_cuda_sms 80" ;;
                      AMPERE86)         ax_cuda_sms="$ax_cuda_sms 86" ;;
                      ADA89)            ax_cuda_sms="$ax_cuda_sms 89" ;;
                      HOPPER|HOPPER90)  ax_cuda_sms="$ax_cuda_sms 90" ;;
                      AMD_GFX*)         ;; dnl handled below in HIP section
                    esac
                  done

                  dnl Unique & sorted
                  ax_cuda_sms=`printf "%s\n" $ax_cuda_sms | awk '!seen[$0]++'`

                  dnl Emit nvcc -gencode flags (compute+code pairs)
                  if test "x$ax_cuda_sms" != x; then
                    for sm in $ax_cuda_sms; do
                      KOKKOS_CXXFLAGS="-gencode=arch=compute_${sm},code=sm_${sm} $KOKKOS_CXXFLAGS"
                    done
                  fi

                  ;;
                hip)
                  AC_PATH_PROG([HIPCC],[hipcc],[no],[$PATH])
                  AS_IF([test "x$HIPCC" = "xno"],
                    [AC_MSG_ERROR([hipcc not found but Kokkos HIP backend requested])])
                  KOKKOS_CXX="$HIPCC"
                  ;;
                sycl)
                  AC_PATH_PROG([ICPX],[icpx],[no],[$PATH])
                  AS_IF([test "x$ICPX" = "xno"],
                    [AC_MSG_ERROR([icpx not found but Kokkos SYCL backend requested])])
                  KOKKOS_CXX="$ICPX"
                  KOKKOS_CXXFLAGS="-fsycl"
                  KOKKOS_LDFLAGS="-fsycl $KOKKOS_LDFLAGS"
                  ;;
                openmp)
                  KOKKOS_CXX="${CXX}"
                  KOKKOS_CXXFLAGS="-x c++ $KOKKOS_CXXFLAGS"
                  ;;
                serial|*)
                  KOKKOS_CXX="${CXX}"
                  KOKKOS_CXXFLAGS="-x c++"
                  ;;
              esac
            ],
            [AC_MSG_RESULT([Using caller-provided KOKKOS_CXX=$KOKKOS_CXX])])

          dnl If we're using OpenMP, we probably want to add
          dnl OpenMP flags if we can.  Some compilers don't accept the
          dnl common flag, so we test first.
          AS_IF([test "x$have_kokkos_openmp" = "xyes"],
            [
              AC_MSG_CHECKING([whether the Kokkos compiler supports -fopenmp])

              acsm_save_CXX="$CXX"
              acsm_save_CXXFLAGS="$CXXFLAGS"

              CXX="$KOKKOS_CXX"
              CXXFLAGS="$CXXFLAGS $KOKKOS_CXXFLAGS -fopenmp"
              AC_LANG_PUSH([C++])

              AC_COMPILE_IFELSE([AC_LANG_PROGRAM([@%:@include <vector>],
                [
                  std::vector<int> v;
                  v.push_back(1);
                ])],
                [
                  KOKKOS_CXXFLAGS="$KOKKOS_CXXFLAGS -fopenmp"
                  KOKKOS_LDFLAGS="$KOKKOS_LDFLAGS -fopenmp"
                  AC_MSG_RESULT([yes])
                ],
                [ AC_MSG_RESULT([no]) ]
               )
              CXXFLAGS="$acsm_save_CXXFLAGS"
              CXX="$acsm_save_CXX"
              AC_LANG_POP([C++])
            ])

          dnl If KOKKOS_CXX differs from the main compiler, it may not be the MPI
          dnl wrapper and thus may need the wrapper's compile flags explicitly in
          dnl order to find mpi.h.  Query the primary CXX wrapper for compile-time
          dnl flags and fall back to MPI_INCLUDES when probing is unavailable.
          KOKKOS_MPI_CPPFLAGS=""
          AS_IF([test "x$enablempi" = "xyes" && test "x$KOKKOS_CXX" != "x$CXX"],
            [
              AC_MSG_CHECKING([for MPI compile flags usable with KOKKOS_CXX])

              dnl Check for flags from OpenMPI mpicxx
              KOKKOS_MPI_CPPFLAGS=`$CXX -showme:compile 2>/dev/null`

              dnl If we found no OpenMPI results, try MPICH arguments
              AS_IF([test "x$KOKKOS_MPI_CPPFLAGS" = "x"],
                [KOKKOS_MPI_CPPFLAGS=`$CXX -cxx='' -compile_info 2>/dev/null`])

              dnl If we still have nothing, try Intel MPI arguments
              AS_IF([test "x$KOKKOS_MPI_CPPFLAGS" = "x"],
                [KOKKOS_MPI_CPPFLAGS=`$CXX -show 2>/dev/null | sed 's/^[^ ]* //'`])

              dnl Our MPI compiler might be reporting a mix of flags
              dnl we do and do not want.  We could try to retain
              dnl everything that looks like a linker flag or include
              dnl path, but linker flags can get weird, so instead we
              dnl strip out everything that looks like a conflict.

              STRIPPED_FLAGS=""
              for flag in $KOKKOS_MPI_CPPFLAGS; do
                case "$flag" in
                  -O*) # Skip possibly-undesired optimization level
                    ;;
                  -std=*) # Skip possibly-incompatible standard
                    ;;
                  *) # Append everything else
                    STRIPPED_FLAGS="$STRIPPED_FLAGS $flag"
                    ;;
                esac
              done
              KOKKOS_MPI_CPPFLAGS=$STRIPPED_FLAGS

              dnl If we still have nothing, fall back to the env?
              AS_IF([test "x$KOKKOS_MPI_CPPFLAGS" = "x"],
                [KOKKOS_MPI_CPPFLAGS="$MPI_INCLUDES"])

              dnl Report what we finally do or do not have
              AS_IF([test "x$KOKKOS_MPI_CPPFLAGS" = "x"],
                [AC_MSG_RESULT([not found])],
                [AC_MSG_RESULT([$KOKKOS_MPI_CPPFLAGS])])
            ])

          dnl Fail configure early if the chosen Kokkos compiler/flags/libs cannot
          dnl actually compile and link a minimal Kokkos program.
          AC_MSG_CHECKING([whether the Kokkos compiler configuration works])
          acsm_save_CXX="$CXX"
          acsm_save_CPPFLAGS="$CPPFLAGS"
          acsm_save_CXXFLAGS="$CXXFLAGS"
          acsm_save_LDFLAGS="$LDFLAGS"
          acsm_save_LIBS="$LIBS"

          CXX="$KOKKOS_CXX"
          CPPFLAGS="$CPPFLAGS $KOKKOS_CPPFLAGS $KOKKOS_MPI_CPPFLAGS"
          CXXFLAGS="$CXXFLAGS $KOKKOS_CXXFLAGS"
          LDFLAGS="$LDFLAGS $KOKKOS_LDFLAGS"
          LIBS="$LIBS $KOKKOS_LIBS"
          AC_LANG_PUSH([C++])

          AS_IF([test "x$enablempi" = "xyes"],
            [
              LDFLAGS="$LDFLAGS $MPI_LDFLAGS"
              LIBS="$LIBS $MPI_LIBS"
              AC_LINK_IFELSE(
                [AC_LANG_SOURCE([[
  #include <mpi.h>
  #include <Kokkos_Core.hpp>
  int main(int argc, char ** argv)
  {
    MPI_Init(&argc, &argv);
    Kokkos::initialize(argc, argv);
    Kokkos::finalize();
    MPI_Finalize();
    return 0;
  }
  ]])],
                [kokkos_config_works=yes],
                [kokkos_config_works=no])
            ],
            [
              AC_LINK_IFELSE(
                [AC_LANG_SOURCE([[
  #include <Kokkos_Core.hpp>
  int main(int argc, char ** argv)
  {
    Kokkos::initialize(argc, argv);
    Kokkos::finalize();
    return 0;
  }
  ]])],
                [kokkos_config_works=yes],
                [kokkos_config_works=no])
            ])
          AC_LANG_POP([C++])

          CXX="$acsm_save_CXX"
          CPPFLAGS="$acsm_save_CPPFLAGS"
          CXXFLAGS="$acsm_save_CXXFLAGS"
          LDFLAGS="$acsm_save_LDFLAGS"
          LIBS="$acsm_save_LIBS"

          AS_IF([test "x$kokkos_config_works" = "xyes"],
            [AC_MSG_RESULT([yes])],
            [AC_MSG_RESULT([no])
             AC_MSG_ERROR([Kokkos compiler/flags failed to compile and link a minimal test program])])

          AC_DEFINE([HAVE_KOKKOS], [1],
                    [Define if Kokkos support is enabled in libMesh])
          AC_MSG_RESULT(<<< Configuring library with Kokkos support >>>)
        ],
        [
          AC_MSG_WARN([Kokkos not found at $KOKKOS_INCLUDE_DIR -- disabling Kokkos FE support])
          enablekokkos=no
        ])
    ],
    [AC_MSG_NOTICE(<<< Configuring library without Kokkos support >>>)
     enablekokkos=no])

  dnl If Kokkos is not enabled, but it *was* required, error out now
  dnl instead of compiling in an invalid configuration.
  AS_IF([test "$enablekokkos" = "no" && test "$kokkosrequired" = "yes"],
        dnl We return error code 4 here, since 0 means success and 1 is
        dnl indistinguishable from other errors.
        [AC_MSG_ERROR([*** Kokkos was not found, but --enable-kokkos-required was specified.], 4)])

  AC_SUBST([KOKKOS_BACKEND])
  AC_SUBST([KOKKOS_CXX])
  AC_SUBST([KOKKOS_CPPFLAGS])
  AC_SUBST([KOKKOS_CXXFLAGS])
  AC_SUBST([KOKKOS_LDFLAGS])
  AC_SUBST([KOKKOS_LIBS])
  AC_SUBST([KOKKOS_MPI_CPPFLAGS])
  AM_CONDITIONAL(ACSM_ENABLE_KOKKOS, test x$enablekokkos = xyes)
])

