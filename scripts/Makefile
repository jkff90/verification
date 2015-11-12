VLOG_OPTS := -timescale 1ps/1ps

VSIM_OPTS := -c -permit_unmatched_virtual_intf -l vsim.log
VSIM_OPTS += -sv_lib $(VERLIB_HOME)/objects/x32/uvm_reg
VSIM_OPTS += -sv_lib $(VERLIB_HOME)/objects/x32/libsknobs

UVM_TESTNAME := uvm_base_test
UVM_VERBOSITY := UVM_LOW
UVM_OPTS := +UVM_VERBOSITY=$(UVM_VERBOSITY)
UVM_OPTS += +UVM_TESTNAME=$(UVM_TESTNAME)

all: clean vlog vsim

clean:
	rm -rf *.log transcript *.wlf work

vlib:
	if [ ! -d work ]; then vlib work; fi

vlog: vlib
	vlog $(VLOG_OPTS) -f lib.lst -f rtl.lst -f ben.lst | tee vlog.log

vsim:
	vsim hdl_top hvl_top $(VSIM_OPTS) $(UVM_OPTS) -do vsim.do

wave:
	vsim -do "add wave -r /hdl_top/*; radix -h" -view vsim.wlf

.PHONY: all clean vlib vlog vsim wave
