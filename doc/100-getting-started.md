What is it?
============
A project template generator.

The basic idea is to get up and running with an autotool project quickly.
Getting the autotools all setup up nicely is a bit fiddly, so autoscaffold generates a new project for you.

How do I use it for my stuff?
============
1) change the project name in the configure.ac > sed -e 's/vendor-project-name/NewProjectName/' -i"" configure.ac
2) change the project email in the configure.ac > sed -e 's/bugfixes@support-email.com/NewProjectEmail/' -i"" configure.ac
3) add your code in the various directories
4) customise the makefiles to build your sources


What use case lead you to build this?
=====================================

I want to build a number of projects which can be packaged and deployed on posix platforms.
The projects share code and often a common library can be extracted.

Autoscaffold makes it easier to generate all the boilerplate needed to create a project which can be managed in its own right.

Once the code reuse starts, a common problem is the consistency of the underlying build environment.
With a single git controlled repository of the "correct" macro, any improvements, bug fixes etc can be shared across all projects easily.


What advantage does using the autotools give?
=====================================
It worked, so I used it. The basic idea is not limited to the autotools, but I chose to use them in part due to the gnu macro archive.
The core useful things I want out of a build system are mostly available, and I like the packaging / cross-compile support. 

the am directory contains snippets to go into an autoconf.ac
The platform directory contains workaround for issues encountered on various platforms.

Basically its all permissively licensed so feel free

Extending with third party autoconf macros
=====================================
The autotool follows a certain flow.

1) M4 functions generate shell script  - 		stuff in the m4 directory 
2) shell scripts export environment variables		stuff in the build-aux directory
3) configure substitutes the environment variables into templates - generated Makefile.in, config.h.in
4) the templates are combined with user makefiles to form real makefiles. - generated Makefile
5) user runs the real makefiles. - ./configure ; make

Extending with third party autoconf macros for openssl example
=====================================
To to check for openssl support, we need one additional file and to ammend two existing files.
The new file is a m4 macro from the autoconf archive ax_check_openssl.m4, we obtain a copy and store it in the output/m4 directory.
We amend output/configure.ac inserting AX_CHECK_OPENSSL([]) just above the comment '#generate the output'
An example makefile is under example/200-openssl-example-Makefile.am
