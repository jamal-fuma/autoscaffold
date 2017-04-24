include $(top_srcdir)/build-aux/data_common.mk

INCLUDE_DIRS	= -I$(top_builddir) \
				  -I$(top_srcdir)/sources/include

SOURCE_DEFINES  = -DPACKAGE_VERSION="\"${PACKAGE_VERSION}\"" \
				  -D__STDC_LIMIT_MACROS=1 \
				  -DFUMA_BUILD_LABEL="\"${FUMA_BUILD_LABEL}\"" \
				  -DBOOST_SIGNALS_NO_DEPRECATION_WARNING=1

LINKER_FLAGS	= \
		  $(POSTGRES_LDFLAGS) \
		  $(WEBTOOLKIT_LDFLAGS) \
		  $(BOOST_LDFLAGS) \
		  $(PTHREAD_LIBS) \
		  $(COVERAGE_LDFLAGS) \
		  -rdynamic

WARNING_FLAGS	= -Wall -Wextra  -W \
		   -fno-omit-frame-pointer \
		   -pedantic -pedantic-errors \
		  -Wunused-value -Wunused -Wunused-parameter -Wunused-variable \
		  -Wunreachable-code \
		  -Wcast-align -Wcast-qual \
		  -Winit-self \
		  -Wfloat-equal \
		  -Wundef \
		  -Wredundant-decls \
		  -Wshadow -Wstack-protector \
		  -Wdisabled-optimization \
		  -Wmissing-field-initializers -Wmissing-format-attribute -Wformat-nonliteral -Wformat-security -Wformat-y2k \
		  -Wmissing-noreturn \
		  -Wimport  -Winit-self  -Winline \
		  -Wstrict-aliasing=2 \
		  -Wwrite-strings

if FREEBSD
WARNING_FLAGS +=  -ftemplate-backtrace-limit=0
endif

COMPILE_FLAGS	= $(INCLUDE_DIRS) \
		  $(POSTGRES_CPPFLAGS) \
		  $(WEBTOOLKIT_CPPFLAGS) \
		  $(BOOST_CPPFLAGS) \
		  $(PTHREAD_CFLAGS) \
		  $(COVERAGE_CFLAGS) \
		  $(SOURCE_DEFINES)  \
		  $(WARNING_FLAGS)

LINKER_LIBS	= \
		  $(BOOST_SYSTEM_LIB) \
		  $(BOOST_IOSTREAMS_LIB) \
		  $(BOOST_PROGRAM_OPTIONS_LIB) \
		  $(BOOST_REGEX_LIB) \
		  $(BOOST_FILESYSTEM_LIB) \
		  $(WEBTOOLKIT_HTTP_LIBS) \
		  $(WEBTOOLKIT_DBO_LIBS)  \
		  $(POSTGRES_PQ_LIBS) \
		  $(OPENSSL_LIBS) \
		  $(PTHREAD_LIBS)
