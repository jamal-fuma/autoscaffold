include $(top_srcdir)/build-mk/data_common.mk

COMPILE_FLAGS    += $(TEST_DEFINES) -I$(top_srcdir)/tests/include
LINKER_LIBS      += $(BOOST_UNIT_TEST_FRAMEWORK_LIB)
