if HAVE_ASTYLE
astyle:
	$(ASTYLE) -n -R "$(top_srcdir)/sources/*.hpp"
	$(ASTYLE) -n -R "$(top_srcdir)/sources/*.cpp"
	$(ASTYLE) -n -R "$(top_srcdir)/tests/*.hpp"
	$(ASTYLE) -n -R "$(top_srcdir)/tests/*.cpp"
endif # HAVE_ASTYLE
