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
A# SYNOPSIS
#   FUMA_AX_POSTGRES([MINIMUM-VERSION], [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
#
# DESCRIPTION
#
#   Test for the PostgreSQL C++ libraries of a particular version (or newer)
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

AC_DEFUN_ONCE([FUMA_AX_POSTGRES],[dnl
#---------------------------------------------------------------
# FUMA_AX_POSTGRES start
#---------------------------------------------------------------
        fuma_ax_postgres_default_version="9.1.0"

# work out what is the default extension for the platform
# libm - the math library is a fairly safe bet
        AS_IF([test -e "/usr/lib/libm.dylib"],
            [fuma_ax_postgres_default_library_ext=".dylib"],
            [fuma_ax_postgres_default_library_ext=".so"])

        fuma_ax_postgres_default_library_ext="${fuma_ax_postgres_default_library_ext}"
        dnl compare supplied version against the empty string,
        dnl if the caller supplied a version we use that otherwise we use
        dnl fuma_ax_postgres_default_version
        FUMA_AX_SET_POSTGRES_VERSION([ifelse([$1],[],["${fuma_ax_postgres_default_version}"],["$1"])], [desired_postgres])

# save CPPFLAGS/LDFLAGS/LIBS
        FUMA_AX_SAVE_FLAGS([SAVED])

    # set defaults
    fuma_ax_postgres_required="yes"

AC_ARG_WITH([postgres],
        [AS_HELP_STRING([--with-postgres@<:@=ARG@:>@],
            [use PostgreSQL library from a standard location (ARG=yes),
            from the specified location (ARG=<path>),
            or disable it (ARG=no)
            @<:@ARG=yes@:>@ ])],
        [fuma_ax_with_postgres=${withval}], [fuma_ax_with_postgres="yes";])
FUMA_AX_SET_POSTGRES_PATH([fuma_ax_with_postgres],[postgres])

    AC_ARG_WITH([postgres-library-dir],
            AS_HELP_STRING([--with-postgres-library-dir=LIB_DIR],
                [Use given directory for PostgreSQL libraries.]),
            [fuma_ax_with_postgres_library_dir=${withval}], [fuma_ax_with_postgres_library_dir="yes";])
FUMA_AX_SET_POSTGRES_PATH([fuma_ax_with_postgres_library_dir],[postgres_library_dir])

    AC_ARG_WITH([postgres-include-dir],
            AS_HELP_STRING([--with-postgres-include-dir=INCLUDE_DIR],
                [Use given directory for PostgreSQL includes.]),
            [fuma_ax_with_postgres_include_dir=${withval}], [fuma_ax_with_postgres_include_dir="yes";])

FUMA_AX_SET_POSTGRES_PATH([fuma_ax_with_postgres_include_dir],[postgres_include_dir])

# try paths until we find a match
    fuma_ax_postgres_search_paths="/usr/local/Cellar/postgresql/$1
				   /home/user/software/postgres/$1";

    AS_IF([test "x$fuma_ax_postgres_required" = "xyes"], [dnl
            for fuma_ax_postgres_path in $fuma_ax_postgres_path $fuma_ax_postgres_search_paths;
            do
            FUMA_AX_SET_POSTGRES_DIRECTORY_UNLESS_SET([include],[${fuma_ax_postgres_path}/include])
            FUMA_AX_SET_POSTGRES_DIRECTORY_UNLESS_SET([library],[${fuma_ax_postgres_path}/lib])
            FUMA_AX_COMPARE_POSTGRES_HEADER_VERSION([fuma_ax_desired_postgres_version_number],
                [fuma_ax_postgres_version_header_found],[include_dir])

            AS_IF([test "x${fuma_ax_postgres_version_header_found}" = "xyes"], [dnl
                FUMA_AX_CHECK_POSTGRES_PQ_LIBRARY([fuma_ax_postgres_pq_library_found],[library_dir])

                AC_DEFINE([HAVE_POSTGRES],[1],[define if the PostgreSQL library is available])
                break;],[POSTGRES_CPPFLAGS=""])
            done

            AS_IF([test "x${fuma_ax_postgres_version_header_found} x${fuma_ax_postgres_pq_library_found}" = "xyes xyes"],[dnl
# found MySQL
                    AC_SUBST([POSTGRES_DBO_LIBS])
                    fuma_ax_postgres_found="yes"])
                    AC_MSG_RESULT([${fuma_ax_postgres_postgres_backend_found}])
                ],[fuma_ax_postgres_found="no"])

# perform user supplied action if user indeed supplied it.
            AS_IF([test "x$fuma_ax_postgres_found" = "xyes"],
                    [# action on success
                    ifelse([$2], , :, [$2])
                    ],
                    [ # action on failure
                    ifelse([$3], , :, [$3])
                    ])

    AS_IF([test "x$fuma_ax_postgres_found" = "xyes"], [],[dnl
            AC_ERROR([Could not find PostgreSQL library to use])
            ])
    ],
    [dnl
AC_ERROR([fuma_ax_postgres_required is not set to yes, WTF])
    ])

#---------------------------------------------------------------
# FUMA_AX_POSTGRES end
#---------------------------------------------------------------
    ])
