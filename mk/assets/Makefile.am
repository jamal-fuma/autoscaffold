# assets/Makefile.am
include $(top_srcdir)/build-aux/data_common.mk

# configuration for the services
config_v1dir = $(pkg_data_dir)
nobase_dist_config_v1_DATA = \
 $(top_builddir)/example.conf

# generate a config file pointing at a the install location
$(top_builddir)/example.conf: example.conf.in $(top_builddir)/stamp-h1
	sed -e 's![@]confdir[@]!$(pkg_data_dir)!g' \
	    -e 's![@]PACKAGE_VERSION[@]!$(PACKAGE_VERSION)!g' \
	    $< > $@

# distribute but don't install the unpreprocess config file / valgrind suppressions
EXTRA_DIST=\
\
 example.conf.in \
 valgrind.supp

# cleaning generated files is a goodness
CLEANFILES=$(top_builddir)/example.conf

# not explicitly removing things we generate causes distclean to fail and so breaks distcheck
DISTCLEANFILES=$(CLEANFILES)

MAINTAINERCLEANFILES = \
             $(top_srcdir)/assets/Makefile.in \
			 $(DISTCLEANFILES)
