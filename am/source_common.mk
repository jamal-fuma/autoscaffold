include $(top_srcdir)/build-mk/data_common.mk

COMPILE_FLAGS += $(COVERAGE_CFLAGS)
LINKER_FLAGS  += $(COVERAGE_LDFLAGS)
