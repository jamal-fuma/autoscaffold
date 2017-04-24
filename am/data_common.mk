# hang the package configuration directories of the $(sysconfdir) environment
pkg_sysconf_root_dir = $(sysconfdir)/$(PACKAGE_NAME)
pkg_sysconf_dir      = $(pkg_sysconf_root_dir)/$(PACKAGE_VERSION)

# hang the package configuration directories of the $(datadir) environment
pkg_data_root_dir    = $(datadir)/$(PACKAGE_NAME)
pkg_data_dir         = $(pkg_data_root_dir)/$(PACKAGE_VERSION)
