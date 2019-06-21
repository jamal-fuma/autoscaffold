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
AC_DEFUN([FUMA_AX_CHECK_WEBTOOLKIT_TEST_LIBRARY],[dnl
#---------------------------------------------------------------
# FUMA_AX_CHECK_WEBTOOLKIT_TEST_LIBRARY start
#---------------------------------------------------------------
fuma_ax_webtoolkit_test_library_found="no";
AC_MSG_CHECKING([
for libwttest
fuma_ax_webtoolkit_test_library_found="${fuma_ax_webtoolkit_test_library_found}"
])
FUMA_AX_CHECK_LIBRARY([wttest],
                [${WEBTOOLKIT_LDFLAGS}],
                [-lwttest -lwt ${WEBTOOLKIT_LIBS}],
                [${WEBTOOLKIT_CPPFLAGS}],
                [WEBTOOLKIT],
                [WEBTOOLKIT_TEST],
                [[
@%:@include <Wt/Test/WTestEnvironment.h>
]],
                [[
Wt::Test::WTestEnvironment environment;
]],
                [fuma_ax_webtoolkit_test_library_found])
AS_IF([test "x${fuma_ax_webtoolkit_test_library_found}" = "xyes"],[dnl
		AC_SUBST([WEBTOOLKIT_TEST_LIBS])
        AC_DEFINE([HAVE_WEBTOOLKIT_TEST],[1],[define if the Webtoolkit test library is available])
])
AC_MSG_RESULT([
fuma_ax_webtoolkit_test_library_found="${fuma_ax_webtoolkit_test_library_found}"
WEBTOOLKIT_CPPFLAGS="${WEBTOOLKIT_CPPFLAGS}"
WEBTOOLKIT_LDFLAGS="${WEBTOOLKIT_LDFLAGS}"
WEBTOOLKIT_LIBS="${WEBTOOLKIT_LIBS}"
WEBTOOLKIT_TEST_LIBS="${WEBTOOLKIT_TEST_LIBS}"
])
#---------------------------------------------------------------
# FUMA_AX_CHECK_WEBTOOLKIT_TEST_LIBRARY end
#---------------------------------------------------------------
        ])
