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
     # set defaults for our shell variables
    fuma_ax_postgres_default_version="9.4.0"
    fuma_ax_postgres_user_version="$1"
    fuma_ax_postgres_required="no"

# Check whether --with-postgres was given.
    AC_ARG_WITH([postgres],
        [AS_HELP_STRING([--with-postgres=@<:@ARG@:>@],[
            use PostgreSQL from a standard location (ARG=yes),
            from the specified location (ARG=<path>),
            or disable it (ARG=no)
            @<:@ARG=yes@:>@]
            )], [fuma_ax_with_postgres="${withval}"],
        [fuma_ax_with_postgres="${fuma_ax_postgres_required}"])

# Check whether --with-postgres-include-dir was given.
    AC_ARG_WITH([postgres-include-dir],
            [AS_HELP_STRING([--with-postgres-include-dir=@<:@ARG@:>@],[
                override include path for PostgreSQL (ARG=<path>),
                or disable it (ARG=no)
                @<:@ARG=yes@:>@]
                )], [fuma_ax_with_postgres_include_dir=${withval}],
            [fuma_ax_with_postgres_include_dir="/usr/include"])

# Check whether --with-postgres-library-dir was given.
    AC_ARG_WITH([postgres-library-dir],
            [AS_HELP_STRING([--with-postgres-library-dir=@<:@ARG@:>@], [
                override library path for PostgreSQL (ARG=<path>),
                or disable it (ARG=no)
                @<:@ARG=yes@:>@]
                )], [fuma_ax_with_postgres_library_dir=${withval}],
            [fuma_ax_with_postgres_library_dir="/usr/lib/x86_64-linux-gnu"])

    # allow user to skip finding PostgreSQL
    AS_IF([test "x$fuma_ax_with_postgres" = "xno"], [fuma_ax_postgres_required="no"],[
    #--------------------------------------------------------------------------------------
        AC_MSG_CHECKING([setting library and include paths for postgres ])
    #--------------------------------------------------------------------------------------
        include_dir="${fuma_ax_with_postgres_include_dir}"
        library_dir="${fuma_ax_with_postgres_library_dir}"

        fuma_ax_postgres_library_found="no";
        POSTGRES_CPPFLAGS="-I${include_dir}";
        POSTGRES_LIBS="";
        POSTGRES_LDFLAGS="-L${library_dir} -Wl,-rpath,${library_dir}";
    #--------------------------------------------------------------------------------------

        FUMA_AX_CHECK_POSTGRES_LIBRARY([fuma_ax_postgres_library_found])
    #--------------------------------------------------------------------------------------

        AC_MSG_RESULT([
include_dir="${fuma_ax_with_postgres_include_dir}"
library_dir="${fuma_ax_with_postgres_library_dir}"
POSTGRES_LDFLAGS="${POSTGRES_LDFLAGS}";
POSTGRES_CPPFLAGS="${POSTGRES_CPPFLAGS}";
POSTGRES_LIBS="${POSTGRES_LIBS}"
fuma_ax_postgres_library_found="${fuma_ax_postgres_library_found}";])

# perform user supplied action if user indeed supplied it.
    AS_IF([test "x$fuma_ax_postgres_library_found" = "xyes"],
        [# action on success
        ifelse([$2], , :, [$2])
        ],
        [ # action on failure
        ifelse([$3], , :, [$3])
        ])
	])
    #--------------------------------------------------------------------------------------
    #
    #--------------------------------------------------------------------------------------

#---------------------------------------------------------------
# FUMA_AX_POSTGRES end
#---------------------------------------------------------------
])
