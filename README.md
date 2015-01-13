autoscaffold
============
Common M4 files for autotools projects

What is it?
============

A project template generator.

The basic idea is to get up and running with an autotool project quickly.

By default this is setup to generate support for a C++11 project with Boost and Boost.Test, Astyle, Code Coverage, and CCache

The configure.sh script contains a list of the files which constitute the generated project.
n example test is provided to show how to use the provided support for unit test fixtures.

Files in the generated project 
============

../output/
├── Makefile.am 	 - the top level makefile - the SUBDIRS line must be updated when extra directories are added to the directory
├── autogen.sh  	 - regenerates all generated files from a pristine checkout
├── configure.ac 	 - the top level project configuration, once a project is generated - the project name and support email should be changed here

├── build-aux   	 - contains makefile snippets which for manual inclusion into makefiles to share variables / path locations 
│   ├── astyle.mk 	 - when included into a makefile, adds a astyle target which will format source code consistently
│   ├── changelog.mk 	 - when included into a makefile, populates a Changlog file with the git commit history.
│   ├── gcov.mk      	 - when included into a makefile, adds support for generate test coverage reports
│   ├── source_common.mk - should be included into all non-test makefiles, holds all shared makefile variables for non-test sources
│   ├── test_common.mk 	 - should be included into all test makefiles, holds all shared makefile variables for test sources


			 - contains m4 functions which are automatically available to configure.ac
			 - Boost detection from the autoconf macro archive http://www.gnu.org/software/autoconf-archive/
		 	 - C++11 / Pthread /  support from the autoconf macro archive http://www.gnu.org/software/autoconf-archive/
├── m4
│   ├── fuma_ax_astyle.m4 - some astyle rules for c++
│   ├── fuma_ax_cannonical_host.m4 - host detection and build label
│   ├── fuma_ax_ccache.m4 - CCache support
├── scripts
│   ├── centos.sh	  - how to enable scl support on centos as I forget
│   ├── configure.sh	  - wrappers for calling configure in an opinuated way
│   ├── ctags.sh	  - generate ctags for vim
│   └── reallyclean.sh	  - clean all generated files.
├── sources
│   ├── Makefile.am	  - lists the subdirectories to build for a source tree
│   ├── include		  - contains public headers which should be available to tests and sources
│   │   └── Makefile.am   - lists any headers need for the build  
│   ├── lib 		  - contains any libraries the application wishes to build
│   │   └── Makefile.am	  - lists the subdirectories to build for libraries in a source tree
│   └── src
│       └── Makefile.am	  - lists the subdirectories to build for executables in a source tree
└── tests
    ├── Makefile.am	  - lists the subdirectories to build for a test tree
    ├── fixtures
    │   └── fixture.txt	  - a test fixture
    ├── include		  - contains public headers which should be available to tests only
    │   └── Makefile.am   - lists any headers need for the tests
    │   └── TestHelper.hpp - example test header showing how to access fixture support
    ├── lib
    │   └── Makefile.am	  - lists the subdirectories to build tests for libraries in a source tree
    │   └── test_build.cpp - a test which exercises a library in the source tree
    └── src
    │   └── Makefile.am	  - lists the subdirectories to build tests for executables in a source tree
    │   └── test_build.cpp - a test which exercises a executable in the source tree

How do I use it?
============
1) clone the repo  		 > git checkout github.com/jamal-fuma/autoscaffold ./autoscaffold
2) generate an output directory  > cd ./autoscaffold; ./configure.sh
3) see the tests pass 		 > cd output; ./autogen.sh; ./configure; make; make distcheck;

Now make sure to copy the output directory somewhere as running ./configure.sh again will overwrite the output directory.

Licensing
============
The code and build system is permissively licenced, this means you can use bits of it in your own project, mostly you have to keep a comment above the code, but using it doesn't require you to share your changes, (please submit a bug report if any files don't match this discription)

The respective files are all licenced under some variant of this idea, as they either came from the autoconf macro archive, or I wrote them.

Any bugs I find will be pushed back upstream, its nice but not required if you do the same.

The m4 directory contains files from the autoconf macro archive - as such they are licenced individually.
