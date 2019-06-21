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
AC_DEFUN([FUMA_AX_CHECK_WEBTOOLKIT_DBO_POSTGRES_LIBRARY],[dnl
#---------------------------------------------------------------
# FUMA_AX_CHECK_WEBTOOLKIT_DBO_POSTGRES_LIBRARY start
#---------------------------------------------------------------
fuma_ax_webtoolkit_dbo_postgres_library_found="no";
AC_MSG_CHECKING([
for libwtdbo_postgres
fuma_ax_webtoolkit_dbo_postgres_library_found="${fuma_ax_webtoolkit_dbo_postgres_library_found}"
])
FUMA_AX_CHECK_LIBRARY([wtdbopostgres],
                [${WEBTOOLKIT_LDFLAGS}],
                [-lwtdbopostgres -lwtdbo ${WEBTOOLKIT_LIBS}],
                [${WEBTOOLKIT_CPPFLAGS}],
                [WEBTOOLKIT],
                [WEBTOOLKIT_DBO_POSTGRES],
                [[
@%:@include <Wt/Dbo/Session.h>
@%:@include <Wt/Dbo/backend/Postgres.h>
]],
                [[
Wt::Dbo::Session session;
Wt::Dbo::backend::Postgres m_connection;
]],
                [fuma_ax_webtoolkit_dbo_postgres_library_found])
AS_IF([ test "x${fuma_ax_webtoolkit_dbo_postgres_backend_found}" = "xyes"],[dnl
		AC_SUBST([WEBTOOLKIT_DBO_POSTGRES_LIBS])
        AC_DEFINE([HAVE_WEBTOOLKIT_DBO_POSTGRES],[1],[define if the Webtoolkit dbo_postgres library is available])
])
AC_MSG_RESULT([
fuma_ax_webtoolkit_dbo_postgres_library_found="${fuma_ax_webtoolkit_dbo_postgres_library_found}"
WEBTOOLKIT_CPPFLAGS="${WEBTOOLKIT_CPPFLAGS}"
WEBTOOLKIT_LDFLAGS="${WEBTOOLKIT_LDFLAGS}"
WEBTOOLKIT_LIBS="${WEBTOOLKIT_LIBS}"
WEBTOOLKIT_DBO_POSTGRES_LIBS="${WEBTOOLKIT_DBO_POSTGRES_LIBS}"
])
#---------------------------------------------------------------
# FUMA_AX_CHECK_WEBTOOLKIT_DBO_POSTGRES_LIBRARY end
#---------------------------------------------------------------
        ])
