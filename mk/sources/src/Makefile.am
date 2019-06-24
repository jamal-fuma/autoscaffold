# sources/src/Makefile.am

include $(top_srcdir)/build-mk/source_common.mk

SUBDIRS = \
 .

bin_PROGRAMS = \


# implicitly set for( % : $(bin_PROGRAMS) ) %_SOURCES = %.cpp
AM_DEFAULT_SOURCE_EXT = .cpp

AM_LDFLAGS  = $(LINKER_FLAGS)
AM_CPPFLAGS = $(COMPILE_FLAGS)

# implicitly set for( % : $(bin_PROGRAMS) ) %LD_ADD = $(LINKER_LIBS)
LDADD = \
	$(LINKER_LIBS)

MAINTAINERCLEANFILES = \
 $(top_srcdir)/sources/src/Makefile.in
