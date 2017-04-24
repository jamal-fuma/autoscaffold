#!/bin/sh
# (c) FumaSoftware 2012
#
# Generate a configure.ac  with boost, unit tests and c++11 support
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
#
output_dir=${1:-'missing'}

APP_NAME="${0}"
APP_DIR=`dirname ${APP_NAME}`
ABS_PATH="$( cd "$APP_DIR" && pwd )"

m4_files=$(cat <<EOF
${ABS_PATH}/m4/ax_boost_base.m4
${ABS_PATH}/m4/ax_boost_filesystem.m4
${ABS_PATH}/m4/ax_boost_iostreams.m4
${ABS_PATH}/m4/ax_boost_program_options.m4
${ABS_PATH}/m4/ax_boost_regex.m4
${ABS_PATH}/m4/ax_boost_system.m4
${ABS_PATH}/m4/ax_boost_unit_test_framework.m4
${ABS_PATH}/m4/ax_cxx_compile_stdcxx.m4
${ABS_PATH}/m4/ax_cxx_compile_stdcxx_14.m4
${ABS_PATH}/m4/ax_pthread.m4
${ABS_PATH}/m4/fuma_ax_cannonical_host.m4
${ABS_PATH}/m4/fuma_ax_cppflags_if_enabled.m4
${ABS_PATH}/m4/fuma_ax_debug.m4
${ABS_PATH}/m4/fuma_ax_platform_types.m4
${ABS_PATH}/m4/fuma_ax_astyle.m4
${ABS_PATH}/m4/fuma_ax_ccache.m4
${ABS_PATH}/m4/fuma_ax_check_library.m4
${ABS_PATH}/m4/fuma_ax_flag_restoration.m4
${ABS_PATH}/m4/fuma_ax_flag_saving.m4
${ABS_PATH}/m4/fuma_ax_check_postgres_pq.m4
${ABS_PATH}/m4/fuma_ax_postgres.m4
${ABS_PATH}/m4/fuma_ax_set_postgres_path.m4
${ABS_PATH}/m4/fuma_ax_set_postgres_version.m4
${ABS_PATH}/m4/fuma_ax_compare_postgres_header_version.m4
${ABS_PATH}/m4/fuma_ax_set_postgres_directory_unless_set.m4
${ABS_PATH}/m4/fuma_ax_webtoolkit.m4
${ABS_PATH}/m4/fuma_ax_check_webtoolkit_dbo_mysql.m4
${ABS_PATH}/m4/fuma_ax_check_webtoolkit_dbo_postgres_library.m4
${ABS_PATH}/m4/fuma_ax_check_webtoolkit_dbo_sqlite3_library.m4
${ABS_PATH}/m4/fuma_ax_check_webtoolkit_http_library.m4
${ABS_PATH}/m4/fuma_ax_check_webtoolkit_test_library.m4
${ABS_PATH}/m4/fuma_ax_set_webtoolkit_directory_unless_set.m4
${ABS_PATH}/m4/fuma_ax_set_webtoolkit_path.m4
${ABS_PATH}/m4/fuma_ax_set_webtoolkit_version.m4
${ABS_PATH}/m4/fuma_ax_compare_webtoolkit_header_version.m4
${ABS_PATH}/m4/gcov.m4
${ABS_PATH}/m4/ax_lib_mysql.m4
EOF
)

build_aux_files=$(cat <<EOF
${ABS_PATH}/am/astyle.mk
${ABS_PATH}/am/changelog.mk
${ABS_PATH}/am/data_common.mk
${ABS_PATH}/am/source_common.mk
${ABS_PATH}/am/test_common.mk
${ABS_PATH}/am/gcov.mk
${ABS_PATH}/am/version.mk
${ABS_PATH}/stubs/PROJECT
${ABS_PATH}/stubs/VERSION
${ABS_PATH}/stubs/SUPPORT_EMAIL
EOF
)

script_files=$(cat <<EOF
${ABS_PATH}/scripts/centos.sh
${ABS_PATH}/scripts/configure.sh
${ABS_PATH}/scripts/ctags.sh
${ABS_PATH}/scripts/reallyclean.sh
${ABS_PATH}/scripts/valgrind.sh
${ABS_PATH}/scripts/run.sh
EOF
)

# generate configure script
ConfigureFragments=$(cat <<EOF
${ABS_PATH}/am/additional-build-machinary.ac
${ABS_PATH}/am/automake.ac
${ABS_PATH}/am/silent-rules.ac
${ABS_PATH}/am/disable-detection-of-compilers-unused-by-me.ac
${ABS_PATH}/am/cpp14.ac
${ABS_PATH}/am/programs.ac
${ABS_PATH}/am/astyle.ac
${ABS_PATH}/am/ccache.ac
${ABS_PATH}/am/coverage.ac
${ABS_PATH}/am/fuma.ac
${ABS_PATH}/am/headers.ac
${ABS_PATH}/am/pthread.ac
${ABS_PATH}/am/boost.ac
${ABS_PATH}/am/postgres.ac
${ABS_PATH}/am/webtoolkit.ac
${ABS_PATH}/am/openssl.ac
${ABS_PATH}/am/output.ac
EOF
)

if [ "missing" = ${output_dir} ];
then
	printf "%s: Error: %s\n" "$APP_NAME" "You need to tell me which directory to poplulate with all my files";
	exit `false`;
fi

if [ ! -d ${output_dir} ];
then
	mkdir ${output_dir};
fi

# copy makefiles
(cd ${ABS_PATH}/mk; tar cf - . ) | ( cd ${output_dir}; tar xf - );

# copy test helper
mkdir ${output_dir}/tests/fixtures
cp ${ABS_PATH}/stubs/TestHelper.hpp ${output_dir}/tests/include/TestHelper.hpp
cp ${ABS_PATH}/stubs/test_build.cpp ${output_dir}/tests/src/
cp ${ABS_PATH}/stubs/test_build.cpp ${output_dir}/tests/lib
cp ${ABS_PATH}/stubs/fixture.txt ${output_dir}/tests/fixtures/

# assemble configure.ac
cat $ConfigureFragments > ${output_dir}/configure.ac

# copy over supporting build fragments
mkdir -p ${output_dir}/build-aux;
for f in $build_aux_files; do
	cp $f ${output_dir}/build-aux/`basename $f`;
done

# copy over supporting m4 fragments
mkdir -p ${output_dir}/m4;
for f in $m4_files; do
	cp $f ${output_dir}/m4/`basename $f`;
done

# copy over supporting scripts
mkdir -p ${output_dir}/scripts;
for f in $script_files; do
	cp $f ${output_dir}/scripts/`basename $f`;
done

printf "%s\n" "autoreconf -fvi" > ${output_dir}/autogen.sh
chmod +x ${output_dir}/autogen.sh
