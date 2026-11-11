# Makefile

# defaults
SIM ?= icarus

TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += mult_8_feedback.v

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = mult_8_feedback

# MODULE is the basename of the Python test file
MODULE = test_mult_8_feedback

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
