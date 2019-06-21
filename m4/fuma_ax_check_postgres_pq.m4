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
AC_DEFUN([FUMA_AX_CHECK_POSTGRES_LIBRARY],[dnl
#---------------------------------------------------------------
# FUMA_AX_CHECK_POSTGRES_LIBRARY start
#---------------------------------------------------------------
fuma_ax_postgres_library_found="no";
    AC_MSG_CHECKING([
for libpostgres
fuma_ax_postgres_library_found="${fuma_ax_postgres_library_found}"
    ])

    FUMA_AX_CHECK_LIBRARY([pq],
        [${POSTGRES_LDFLAGS}],
        [-lpq ${POSTGRES_LIBS}],
        [${POSTGRES_CPPFLAGS}],
        [POSTGRES],
        [POSTGRES],
        [[
@%:@include <postgresql/libpq-fe.h>
]],
        [[
int input = PQlibVersion();
]],
        [fuma_ax_postgres_library_found])

    AC_MSG_RESULT([
fuma_ax_postgres_library_found="${fuma_ax_postgres_library_found}";
POSTGRES_LDFLAGS="${POSTGRES_LDFLAGS}";
POSTGRES_CPPFLAGS="${POSTGRES_CPPFLAGS}";
POSTGRES_LIBS="${POSTGRES_LIBS}"
    ])
#---------------------------------------------------------------
# FUMA_AX_CHECK_POSTGRES_LIBRARY end
#---------------------------------------------------------------
])
