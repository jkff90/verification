VLOG_OPTS := -timescale 1ps/1ps

VSIM_OPTS := -c -permit_unmatched_virtual_intf -l vsim.log
VSIM_OPTS += -sv_lib $(VERLIB_HOME)/objects/i686/uvm_reg
VSIM_OPTS += -sv_lib $(VERLIB_HOME)/objects/i686/libsknobs

UVM_TESTNAME := uvm_base_test
UVM_VERBOSITY := UVM_LOW
UVM_OPTS := +UVM_VERBOSITY=$(UVM_VERBOSITY)
UVM_OPTS += +UVM_TESTNAME=$(UVM_TESTNAME)
SEED := $$RANDOM

all: clean vlog vsim

check:
	if [ -z $(VERLIB_HOME) ]; then exit 1; fi

clean:
	rm -rf *.log transcript *.wlf work

vlib:
	if [ ! -d work ]; then vlib work; fi

vlog: check vlib
	vlog $(VLOG_OPTS) -f lib.lst -f rtl.lst -f ben.lst | tee vlog.log

vsim: check
	vsim hdl_top hvl_top $(VSIM_OPTS) $(UVM_OPTS) -do vsim.do -seed $(SEED)

wave:
	vsim -do "add wave -r /hdl_top/*; radix -h" -view vsim.wlf

.PHONY: all clean vlib vlog vsim wave
