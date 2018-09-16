VLOG_OPTS := -64 -timescale 1ns/1ns

VSIM_OPTS := -c -64 -permit_unmatched_virtual_intf -l vsim.log
VSIM_OPTS += -sv_lib $(VERILIB_HOME)/objects/$(PLATFORM)/$(ARCH)/uvm_dpi
VSIM_OPTS += -sv_lib $(VERILIB_HOME)/objects/$(PLATFORM)/$(ARCH)/libsknobs

UVM_TESTNAME := video_file_test
UVM_VERBOSITY := UVM_LOW
UVM_OPTS := +UVM_VERBOSITY=$(UVM_VERBOSITY)
UVM_OPTS += +UVM_TESTNAME=$(UVM_TESTNAME)

all: clean vlog vsim

check:
	if [ -z $(VERILIB_HOME) ]; then exit 1; fi

clean:
	rm -rf *.log transcript modelsim.ini *.wlf verilib work

verilib:
	if [ ! -d verilib ]; then \
		vlib verilib; \
		vmap verilib verilib; \
		vlog -work verilib -f lib.lst; \
	fi

vlib:
	if [ ! -d work ]; then vlib work; fi

vlog: check verilib vlib
	vlog $(VLOG_OPTS) -L verilib -f rtl.lst -f ben.lst | tee vlog.log

vsim: check
	vsim hdl_top hvl_top $(VSIM_OPTS) $(UVM_OPTS) -do vsim.do

wave:
	vsim -do "add wave -r /hdl_top/*; radix -h" -view vsim.wlf

.PHONY: all check clean verilib vlib vlog vsim wave
