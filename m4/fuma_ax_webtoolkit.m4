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
#   FUMA_AX_WEBTOOLKIT([MINIMUM-VERSION], [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
#
# DESCRIPTION
#
#   Test for the Webtoolkit C++ libraries of a particular version (or newer)
#
#   This macro calls:
#
#     AC_SUBST(WEBTOOLKIT_CPPFLAGS) / AC_SUBST(WEBTOOLKIT_LDFLAGS)
#     AC_SUBST([WEBTOOLKIT_HTTP_LIBS])
#     AC_SUBST([WEBTOOLKIT_TEST_LIBS])
#
#   And sets:
#
#     HAVE_WEBTOOLKIT
#     HAVE_WEBTOOLKIT_HTTP
#     HAVE_WEBTOOLKIT_TEST
#
# LICENSE
# (c) FumaSoftware 2015

AC_DEFUN_ONCE([FUMA_AX_WEBTOOLKIT],[
#---------------------------------------------------------------
# FUMA_AX_WEBTOOLKIT start
#---------------------------------------------------------------
    # set defaults for our shell variables
    fuma_ax_webtoolkit_default_version="4.0.5"
    fuma_ax_webtoolkit_user_version="$1"
    fuma_ax_webtoolkit_required="no"

# Check whether --with-webtoolkit was given.
    AC_ARG_WITH([webtoolkit],
        [AS_HELP_STRING([--with-webtoolkit=@<:@ARG@:>@],[
            use WebToolkit from a standard location (ARG=yes),
            from the specified location (ARG=<path>),
            or disable it (ARG=no)
            @<:@ARG=yes@:>@]
            )], [fuma_ax_with_webtoolkit="${withval}"],
        [fuma_ax_with_webtoolkit="${fuma_ax_webtoolkit_required}"])

# Check whether --with-webtoolkit-include-dir was given.
    AC_ARG_WITH([webtoolkit-include-dir],
            [AS_HELP_STRING([--with-webtoolkit-include-dir=@<:@ARG@:>@],[
                override include path for WebToolkit (ARG=<path>),
                or disable it (ARG=no)
                @<:@ARG=yes@:>@]
                )], [fuma_ax_with_webtoolkit_include_dir=${withval}],
            [fuma_ax_with_webtoolkit_include_dir="/usr/include"])

# Check whether --with-webtoolkit-library-dir was given.
    AC_ARG_WITH([webtoolkit-library-dir],
            [AS_HELP_STRING([--with-webtoolkit-library-dir=@<:@ARG@:>@], [
                override library path for WebToolkit (ARG=<path>),
                or disable it (ARG=no)
                @<:@ARG=yes@:>@]
                )], [fuma_ax_with_webtoolkit_library_dir=${withval}],
            [fuma_ax_with_webtoolkit_library_dir="/usr/lib/x86_64-linux-gnu"])

    # allow user to skip finding WebToolkit
    AS_IF([test "x$fuma_ax_with_webtoolkit" = "xno"], [fuma_ax_webtoolkit_required="no"],[
    #--------------------------------------------------------------------------------------
        AC_MSG_CHECKING([setting library and include paths for webtoolkit ])
    #--------------------------------------------------------------------------------------
        include_dir="${fuma_ax_with_webtoolkit_include_dir}"
        library_dir="${fuma_ax_with_webtoolkit_library_dir}"

        fuma_ax_webtoolkit_http_library_found="no";
        fuma_ax_webtoolkit_test_library_found="no";
        fuma_ax_webtoolkit_dbo_sqlite3_library_found="no";
        fuma_ax_webtoolkit_dbo_mysql_library_found="no";
        fuma_ax_webtoolkit_dbo_postgres_library_found="no";

        WEBTOOLKIT_CPPFLAGS="-I${include_dir} ${BOOST_CPPFLAGS}";
        WEBTOOLKIT_LIBS="${BOOST_SYSTEM_LIB} ${PTHREAD_LIBS}";
        WEBTOOLKIT_LDFLAGS="-L${library_dir} -Wl,-rpath,${library_dir} ${BOOST_LDFLAGS}";
        WEBTOOLKIT_DBO_LIBS="${WEBTOOLKIT_DBO_MYSQL_LIBS} ${WEBTOOLKIT_DBO_POSTGRES_LIBS} ${WEBTOOLKIT_DBO_SQLITE3_LIBS}";

        AC_MSG_RESULT([
include_dir="${fuma_ax_with_webtoolkit_include_dir}"
library_dir="${fuma_ax_with_webtoolkit_library_dir}"
WEBTOOLKIT_LDFLAGS="${WEBTOOLKIT_LDFLAGS}";
WEBTOOLKIT_CPPFLAGS="${WEBTOOLKIT_CPPFLAGS}";
WEBTOOLKIT_LIBS="${WEBTOOLKIT_LIBS}"
WEBTOOLKIT_DBO_LIBS="${WEBTOOLKIT_DBO_LIBS}"
fuma_ax_webtoolkit_http_library_found="${fuma_ax_webtoolkit_http_library_found}";
fuma_ax_webtoolkit_test_library_found="${fuma_ax_webtoolkit_test_library_found}";
fuma_ax_webtoolkit_dbo_sqlite3_library_found="${fuma_ax_webtoolkit_dbo_sqlite3_library_found}";
fuma_ax_webtoolkit_dbo_mysql_library_found="${fuma_ax_webtoolkit_dbo_mysql_library_found}";
fuma_ax_webtoolkit_dbo_postgres_library_found="${fuma_ax_webtoolkit_dbo_postgres_library_found}";])

    #--------------------------------------------------------------------------------------

        FUMA_AX_CHECK_WEBTOOLKIT_HTTP_LIBRARY([fuma_ax_webtoolkit_http_library_found])
        FUMA_AX_CHECK_WEBTOOLKIT_TEST_LIBRARY([fuma_ax_webtoolkit_test_library_found])
        FUMA_AX_CHECK_WEBTOOLKIT_DBO_SQLITE3_LIBRARY([fuma_ax_webtoolkit_dbo_sqlite3_library_found])
        FUMA_AX_CHECK_WEBTOOLKIT_DBO_MYSQL_LIBRARY([fuma_ax_webtoolkit_dbo_mysql_library_found])
        FUMA_AX_CHECK_WEBTOOLKIT_DBO_POSTGRES_LIBRARY([fuma_ax_webtoolkit_dbo_postgres_library_found])

        AS_IF([test "x${fuma_ax_webtoolkit_dbo_mysql_library_found}" = "xyes"],[ WEBTOOLKIT_DBO_LIBS="${WEBTOOLKIT_DBO_LIBS} ${WEBTOOLKIT_DBO_MYSQL_LIBS}"; ])
        AS_IF([test "x${fuma_ax_webtoolkit_dbo_sqlite3_library_found}" = "xyes"],[ WEBTOOLKIT_DBO_LIBS="${WEBTOOLKIT_DBO_LIBS} ${WEBTOOLKIT_DBO_SQLITE3_LIBS}"; ])
        AS_IF([test "x${fuma_ax_webtoolkit_dbo_postgres_library_found}" = "xyes"],[ WEBTOOLKIT_DBO_LIBS="${WEBTOOLKIT_DBO_LIBS} ${WEBTOOLKIT_DBO_POSTGRES_LIBS}"; ])

        AC_SUBST([WEBTOOLKIT_DBO_LIBS])

    #--------------------------------------------------------------------------------------

        AC_MSG_RESULT([
include_dir="${fuma_ax_with_webtoolkit_include_dir}"
library_dir="${fuma_ax_with_webtoolkit_library_dir}"
WEBTOOLKIT_LDFLAGS="${WEBTOOLKIT_LDFLAGS}";
WEBTOOLKIT_CPPFLAGS="${WEBTOOLKIT_CPPFLAGS}";
WEBTOOLKIT_LIBS="${WEBTOOLKIT_LIBS}"
WEBTOOLKIT_DBO_LIBS="${WEBTOOLKIT_DBO_LIBS}"
fuma_ax_webtoolkit_http_library_found="${fuma_ax_webtoolkit_http_library_found}";
fuma_ax_webtoolkit_test_library_found="${fuma_ax_webtoolkit_test_library_found}";
fuma_ax_webtoolkit_dbo_sqlite3_library_found="${fuma_ax_webtoolkit_dbo_sqlite3_library_found}";
fuma_ax_webtoolkit_dbo_mysql_library_found="${fuma_ax_webtoolkit_dbo_mysql_library_found}";
fuma_ax_webtoolkit_dbo_postgres_library_found="${fuma_ax_webtoolkit_dbo_postgres_library_found}";])


# perform user supplied action if user indeed supplied it.
        AS_IF([test "x$fuma_ax_webtoolkit_http_library_found" = "xyes"],
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
# FUMA_AX_WEBTOOLKIT end
#---------------------------------------------------------------
])
