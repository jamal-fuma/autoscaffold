dnl (c) FumaSoftware 2015
dnl
dnl Platform detection for autotools
dnl
dnl Copying and distribution of this file, with or without modification,
dnl are permitted in any medium without royalty provided the copyright
dnl notice and this notice are preserved.  This file is offered as-is,
dnl without any warranty.
dnl
dnl platform detection
# SYNOPSIS
#   FUMA_AX_POSTGRES([MINIMUM-VERSION], [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
#
# DESCRIPTION
#
#   Test for the PostgreSQL C++ libraries of a particular version (or newer)
#
#   adds the following arguments to configure
#       --with-postgres
#       --with-postgres-include-dir
#       --with-postgres-library-dir
#
#   This macro calls:
#
#     AC_SUBST(POSTGRES_CPPFLAGS) / AC_SUBST(POSTGRES_LDFLAGS)
#     AC_SUBST([POSTGRES_PQ_LIBS])
#
#   And sets:
#
#     HAVE_POSTGRES
#     HAVE_POSTGRES_PQ
#
# LICENSE
# (c) FumaSoftware 2015

AC_DEFUN_ONCE([FUMA_AX_POSTGRES_WITH_ARGUMENTS],[dnl
#---------------------------------------------------------------
# Check whether --with-$1 was given.
#---------------------------------------------------------------
     AC_ARG_WITH([$1],
                 [AS_HELP_STRING([--with-$1=@<:@ARG@:>@],[
use $2 from a standard location (ARG=yes),
from the specified location (ARG=<path>),
of the specified version (ARG=<version>),
or disable it (ARG=no) @<:@ARG=no@:>@
eg with --with-$1=no])],
                [with_$1="$withval"],
                [with_$1="no"])

    # Check whether --with-$1-include-dir was given.
    AC_ARG_WITH([$1-include-dir],
                [AS_HELP_STRING([--with-$1-include-dir=@<:@ARG@:>@],
                                [override include path for $1 (ARG=path)])],
                [with_$1_include_dir="$withval"],
                [with_$1_include_dir=""])

    # Check whether --with-$1-library-dir was given.
    AC_ARG_WITH([$1-library-dir],
                [AS_HELP_STRING([--with-$1-library-dir=@<:@ARG@:>@],
                [override library path for $1 (ARG=path)])],
                [with_$1_library_dir="$withval"],
                [with_$1_library_dir=""])

    # if the caller specified a version with --postgres=x.y.z then use that, otherwise if the macro specified a version in configure.ac
    # use that, otherwise we fallback to a default version
    fuma_ax_$1_user_version=`expr "$with_$1" : '\([[0-9]]\{1,\}\([[.]]\{1\}[[0-9]]\{1,\}\)\{0,2\}\)'`
#---------------------------------------------------------------
])

AC_DEFUN_ONCE([FUMA_AX_POSTGRES_WITH_PATH_SET_PATH],[dnl
#---------------------------------------------------------------
# use the specified location for checking for $1 $2
#---------------------------------------------------------------
    set -x
    AS_IF([test -d "${with_$1}"],[dnl
        AS_IF([test -d "${with_$1_$2}"],
              [fuma_ax_$1_$2_path="${with_$1_$2}"],
              [fuma_ax_$1_$2_path="${with_$1}/$3"])
        AS_IF([test -d "${fuma_ax_$1_$2_path}"],
              [$2="${fuma_ax_$1_$2_path}"],
              [$2=""])
    ])
    AS_IF([test "x${with_$1}" = "xyes"],[dnl
        AS_IF([test -d "${with_$1_$2}"],
              [fuma_ax_$1_$2_path="${with_$1_$2}"
               $2="${fuma_ax_$1_$2_path}"],
              [$2=""])
    ])
    set +x
#---------------------------------------------------------------
])

AC_DEFUN_ONCE([FUMA_AX_POSTGRES],[dnl
#---------------------------------------------------------------
# FUMA_AX_POSTGRES start
#---------------------------------------------------------------
    FUMA_AX_POSTGRES_WITH_ARGUMENTS([postgres],[PostgresSQL])

    AS_IF([test "x${fuma_ax_postgres_user_version}" = "x"],[fuma_ax_postgres_user_version="$1"])
    AS_IF([test "x${fuma_ax_postgres_user_version}" = "x"],[fuma_ax_postgres_user_version="$fuma_ax_postgres_default_version"])
    FUMA_AX_SET_POSTGRES_VERSION([$fuma_ax_postgres_user_version],
                                 [desired_postgres])

#---------------------------------------------------------------
    #set defaults for our shell variables
#---------------------------------------------------------------
    fuma_ax_postgres_default_version="9.4.0"
    fuma_ax_postgres_default_library_ext="${fuma_ax_default_library_ext}"
    fuma_ax_postgres_found="no"
    fuma_ax_postgres_library_dir_path=""
    fuma_ax_postgres_include_dir_path=""

#---------------------------------------------------------------
# if the caller supplied a version we use that otherwise we use fuma_ax_postgres_default_version in search paths
#---------------------------------------------------------------
    FUMA_AX_POSTGRES_WITH_PATH_SET_PATH([postgres],[include_dir],[include])
    FUMA_AX_POSTGRES_WITH_PATH_SET_PATH([postgres],[library_dir],[lib])

    fuma_ax_postgres_search_path="/usr/local/Cellar/postgresql/${fuma_ax_desired_postgres_version_str}";

    # override search path if we got an explicit path
   AS_IF([test "x${include_dir}" = "x"],[include_dir="${fuma_ax_postgres_search_path}/include"])
   AS_IF([test "x${library_dir}" = "x"],[library_dir="${fuma_ax_postgres_search_path}/lib"])

    #---------------------------------------------------------------
    # try paths until we find a match
    #---------------------------------------------------------------
    AS_IF([test "x${with_postgres}" != "xno"],
          [# check if the header is present by invoking the compiler
           # technically a conforming compiler doesn't need to provided a file to read
           # provided the sematics are honoured, the C++17 modules proposal might actually
           # cause this to be more than a theoretical possiblity
           fuma_ax_postgres_version_header_found=no
           FUMA_AX_COMPARE_POSTGRES_HEADER_VERSION([fuma_ax_desired_postgres_version_str],
                                                   [fuma_ax_postgres_version_header_found],
                                                   [include_dir])

            # fixme, doesn't seem to actually be an easy way to check version
            # short of calling pg_config which breaks cross-compilation
            # easiest way is to depend on a function introduced after version X
            # we are clamping to v9.1 +
            fuma_ax_postgres_pq_library_found="no"
            AS_IF([test "x${fuma_ax_postgres_version_header_found}" = "xyes"],
                [FUMA_AX_CHECK_POSTGRES_PQ_LIBRARY([fuma_ax_postgres_pq_library_found],
                                                   [library_dir])])

            fuma_ax_postgres_found="no"
            AS_IF([test "x${fuma_ax_postgres_pq_library_found}" = "xyes"],
                  [fuma_ax_postgres_found="yes"])])

    #---------------------------------------------------------------
    # report results of search and dispatch user supplied callbacks
    #---------------------------------------------------------------
    AS_IF([test "x${with_postgres}" != "xno"],
          [AC_MSG_CHECKING([if PostgreSQL is available using the provided options, try --with-postgres=version or --with-postgres=path if this fails when you expect it to work])
            AC_MSG_RESULT([${fuma_ax_postgres_found}])

            # this will be used in witty detection
            fuma_ax_with_postgres="${fuma_ax_postgres_found}";

            AS_IF([test "x$fuma_ax_postgres_found" = "xno"],
                    [ifelse([$3],,:,[$3])],
                    [ifelse([$2],,:,[$2])])])
#---------------------------------------------------------------
# FUMA_AX_POSTGRES end
#---------------------------------------------------------------
])
