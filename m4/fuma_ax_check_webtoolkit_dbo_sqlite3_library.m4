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
AC_DEFUN([FUMA_AX_CHECK_WEBTOOLKIT_DBO_SQLITE3_LIBRARY],[dnl
#---------------------------------------------------------------
# FUMA_AX_CHECK_WEBTOOLKIT_DBO_SQLITE3_LIBRARY start
#---------------------------------------------------------------
fuma_ax_webtoolkit_dbo_sqlite3_library_found="no";
AC_MSG_CHECKING([
for libwtdbo_sqlite3
fuma_ax_webtoolkit_dbo_sqlite3_library_found="${fuma_ax_webtoolkit_dbo_sqlite3_library_found}"
])
FUMA_AX_CHECK_LIBRARY([wtdbosqlite3],
                [${WEBTOOLKIT_LDFLAGS}],
                [-lwtdbosqlite3 -lwtdbo ${WEBTOOLKIT_LIBS}],
                [${WEBTOOLKIT_CPPFLAGS}],
                [WEBTOOLKIT],
                [WEBTOOLKIT_DBO_SQLITE3],
                [[
@%:@include <Wt/Dbo/Session.h>
@%:@include <Wt/Dbo/backend/Sqlite3.h>
]],
                [[
Wt::Dbo::Session session;
Wt::Dbo::backend::Sqlite3 m_connection("somefilename.db");
]],
                [fuma_ax_webtoolkit_dbo_sqlite3_library_found])
AS_IF([test "x${fuma_ax_webtoolkit_dbo_sqlite3_backend_found}" = "xyes"],[dnl
	AC_SUBST([WEBTOOLKIT_DBO_SQLITE3_LIBS])
        AC_DEFINE([HAVE_WEBTOOLKIT_DBO_SQLITE3],[1],[define if the Webtoolkit dbo_sqlite3 library is available])
])
AC_MSG_RESULT([
fuma_ax_webtoolkit_dbo_sqlite3_library_found="${fuma_ax_webtoolkit_dbo_sqlite3_library_found}"
WEBTOOLKIT_CPPFLAGS="${WEBTOOLKIT_CPPFLAGS}"
WEBTOOLKIT_LDFLAGS="${WEBTOOLKIT_LDFLAGS}"
WEBTOOLKIT_LIBS="${WEBTOOLKIT_LIBS}"
WEBTOOLKIT_DBO_SQLITE3_LIBS="${WEBTOOLKIT_DBO_SQLITE3_LIBS}"
])
#---------------------------------------------------------------
# FUMA_AX_CHECK_WEBTOOLKIT_DBO_SQLITE3_LIBRARY end
#---------------------------------------------------------------
        ])
