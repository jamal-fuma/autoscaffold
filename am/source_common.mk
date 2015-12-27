include $(top_srcdir)/build-aux/data_common.mk

INCLUDE_DIRS	= -I$(top_builddir) \
				  -I$(top_srcdir)/sources/include \
				  -I$(top_srcdir)/sources/include/3rd_party

SOURCE_DEFINES  = -DPACKAGE_VERSION="\"${PACKAGE_VERSION}\"" \
				  -DFUMA_CONFIG_DIR="\"${pkg_sysconf_dir}\"" \
				  -DFUMA_DATA_DIR="\"${pkg_data_dir}\"" \
				  -D__STDC_LIMIT_MACROS=1 \
				  -DFUMA_BUILD_LABEL="\"${FUMA_BUILD_LABEL}\"" \
				  -DBOOST_SIGNALS_NO_DEPRECATION_WARNING=1

LINKER_FLAGS	= \
		  $(POSTGRES_LDFLAGS) \
		  $(WEBTOOLKIT_LDFLAGS) \
		  $(BOOST_LDFLAGS) \
		  $(COVERAGE_LDFLAGS) \
		  -rdynamic

WARNING_FLAGS	= -Wall -Wextra -pedantic \
		  -Wunused-value \
		  -Wcast-align \
		  -Wno-unused-parameter \
		  -Wunused-variable \
		  -Winit-self \
		  -Wfloat-equal \
		  -Wno-undef \
		  -Wno-shadow \
		  -Wcast-qual \
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
				  $(POSTGRES_PQ_LIBS)     \
				  $(PTHREAD_LIBS)
