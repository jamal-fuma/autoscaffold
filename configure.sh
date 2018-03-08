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

build_mk_files=$(cat <<EOF
${ABS_PATH}/am/data_common.mk
${ABS_PATH}/am/source_common.mk
${ABS_PATH}/am/test_common.mk
EOF
)

asset_files=$(cat <<EOF
${ABS_PATH}/stubs/example.conf.in
${ABS_PATH}/stubs/valgrind.supp
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
${ABS_PATH}/am/mysql.ac
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

if [ ! -d ${output_dir}/.git ];
then
    ( cd ${output_dir} && git init . ; );
fi


# make output directories
for d in ${output_dir}/assets \
    ${output_dir}/sources/src ${output_dir}/sources/include ${output_dir}/sources/lib \
         ${output_dir}/tests/src     ${output_dir}/tests/include   ${output_dir}/tests/lib ${output_dir}/tests/fixtures \
         ${output_dir}/project ${output_dir}/build-mk ;
do
    mkdir -p ${d} || echo "unable to mkdir $d";
done

# populate basic information
basename `pwd` > ${output_dir}/project/NAME
basename `pwd` > ${output_dir}/README.md
git config user.email > ${output_dir}/project/SUPPORT_EMAIL
echo 0.0.1 > ${output_dir}/project/VERSION

( cd ${output_dir} && git add project README.md; );
( cd ${output_dir} && git commit -m "Patch: add basic project metadata" ; );

# git
cat > ${output_dir}/.gitignore<<-EOF
**/Makefile.in
aclocal.m4
autom4te.cache/
build/
config.h.in
configure
EOF

( cd ${output_dir} && git add .gitignore; )
( cd ${output_dir} && git commit -m "Patch: start ignoring generated files" ; );

# copy makefiles
(cd ${ABS_PATH}/mk; tar cf - . ) | ( cd ${output_dir}; tar xf - );
# add generated makefiles to git
( cd ${output_dir} && find . -name 'Makefile.am' | xargs git add  )
( cd ${output_dir} && git commit -m "Patch: add generated makefiles" ; );


# copy test helper
cp ${ABS_PATH}/stubs/TestHelper.hpp ${output_dir}/tests/include/TestHelper.hpp
cp ${ABS_PATH}/stubs/test_build.cpp ${output_dir}/tests/src/
cp ${ABS_PATH}/stubs/test_build.cpp ${output_dir}/tests/lib
cp ${ABS_PATH}/stubs/fixture.txt ${output_dir}/tests/fixtures/


# add generated tests to git
( cd ${output_dir} && find tests -type f | xargs git add  )
( cd ${output_dir} && git commit -m "Patch: add generated test suite" ; );


# assemble configure.ac
cat $ConfigureFragments > ${output_dir}/configure.ac
( cd ${output_dir} &&  git add configure.ac  )
( cd ${output_dir} && git commit -m "Patch: add generated configure.ac to git" ; );

# copy over supporting build fragments
mkdir -p ${output_dir}/build-mk;
for f in $build_mk_files; do
	cp $f ${output_dir}/build-mk/`basename $f`;
done

# add generated build-mk to git
( cd ${output_dir} && find build-mk -type f | xargs git add  )
( cd ${output_dir} && git commit -m "Patch: add generated build-mk" ; );


git submodule add "https://github.com/jamal-fuma/fuma_build_aux.git" "build-aux"
git commit -m "Patch: add build-aux as submodule"

git submodule add "https://github.com/jamal-fuma/fuma_m4.git" "m4"
git commit -m "Patch: add m4 as submodule"

git submodule add "https://github.com/jamal-fuma/fuma_build_scripts.git" "scripts"
git commit -m "Patch: add scripts as submodule"

# copy over supporting assets
mkdir -p ${output_dir}/assets;
for f in ${asset_files}; do
	cp $f ${output_dir}/assets/`basename $f`;
done
( cd ${output_dir} && find assets -type f | xargs git add  )
( cd ${output_dir} && git commit -m "Patch: add generated assets" ; );

# push bootstrap
printf "%s\n" "git submodule update --init --recursive" > ${output_dir}/autogen.sh
printf "%s\n" "autoreconf -fvi" >> ${output_dir}/autogen.sh
chmod +x ${output_dir}/autogen.sh

( cd ${output_dir} &&  git add autogen.sh  )
( cd ${output_dir} && git commit -m "Patch: add generated autogen.sh to git" ; );
