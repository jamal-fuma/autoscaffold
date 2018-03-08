# hang the package configuration directories of the $(sysconfdir) environment
pkg_sysconf_root_dir = $(sysconfdir)/$(PACKAGE_NAME)
pkg_sysconf_dir      = $(pkg_sysconf_root_dir)/$(PACKAGE_VERSION)

# hang the package configuration directories of the $(datadir) environment
pkg_data_root_dir    = $(datadir)/$(PACKAGE_NAME)
pkg_data_dir         = $(pkg_data_root_dir)/$(PACKAGE_VERSION)


INCLUDE_DIRS	= \
  -I$(top_builddir) \
  -I$(top_srcdir)/sources/include \
  -I$(top_srcdir)/sources/include/3rd_party

SOURCE_DEFINES  = \
  -DPACKAGE_VERSION="\"${PACKAGE_VERSION}\"" \
  -DFUMA_CONFIG_DIR="\"${pkg_sysconf_dir}\"" \
  -DFUMA_DATA_DIR="\"${pkg_data_dir}\"" \
  -D__STDC_LIMIT_MACROS=1 \
  -DFUMA_BUILD_LABEL="\"${FUMA_BUILD_LABEL}\""

TEST_DEFINES	= \
  $(SOURCE_DEFINES) \
  -DFIXTURES_DIR="\"${abs_top_srcdir}/tests/fixtures\"" \
  -DFUMA_TEST_CONFIG_DIR="\"${abs_top_srcdir}/assets/config\"" \
  -DFUMA_TEST_DATA_DIR="\"${abs_top_srcdir}/assets\"" \
  -DBOOST_TEST_DYN_LINK="1"

LINKER_FLAGS	= \
  $(POSTGRES_LDFLAGS) \
  $(WEBTOOLKIT_LDFLAGS) \
  $(BOOST_LDFLAGS) \
  $(OPENSSL_LDFLAGS) \
  $(MYSQL_LDFLAGS) \
  $(PTHREAD_CFLAGS) \
  -rdynamic

WARNING_FLAGS = \
-Wall \
-Wextra \
-W \
-fno-omit-frame-pointer \
-pedantic \
-pedantic-errors \
-Wunused-value \
-Wunused \
-Wunused-parameter \
-Wunused-variable \
-Wunreachable-code \
-Wcast-align \
-Wcast-qual \
-Winit-self \
-Wfloat-equal \
-Wundef \
-Wredundant-decls \
-Wshadow \
-Wstack-protector \
-Wdisabled-optimization \
-Wmissing-field-initializers \
-Wmissing-format-attribute \
-Wformat-nonliteral \
-Wformat-security \
-Wformat-y2k \
-Wmissing-noreturn \
-Wimport \
-Winit-self \
-Winline \
-Wstrict-aliasing=2 \
-Wwrite-strings

COMPILE_FLAGS	= \
  $(INCLUDE_DIRS) \
  $(POSTGRES_CPPFLAGS) \
  $(WEBTOOLKIT_CPPFLAGS) \
  $(BOOST_CPPFLAGS) \
  $(OPENSSL_INCLUDES) \
  $(MYSQL_CFLAGS) \
  $(PTHREAD_CFLAGS) \
  $(SOURCE_DEFINES)  \
  $(WARNING_FLAGS)

LINKER_LIBS	= \
  $(BOOST_SYSTEM_LIB) \
  $(BOOST_IOSTREAMS_LIB) \
  $(BOOST_PROGRAM_OPTIONS_LIB) \
  $(BOOST_REGEX_LIB) \
  $(BOOST_FILESYSTEM_LIB) \
  $(WEBTOOLKIT_HTTP_LIBS) \
  $(WEBTOOLKIT_DBO_LIBS) \
  $(POSTGRES_PQ_LIBS) \
  $(OPENSSL_LIBS) \
  $(PTHREAD_LIBS)
