
CXX := gcc
CFLAGS := -shared -m64 -fPIC -Wall -D QUESTA -I $(QUESTA_HOME)/include

all: libsknobs.so uvm_dpi.so

libsknobs.so:
	$(CXX) $(CFLAGS) sknobs.c -o $(PLATFORM)/$(ARCH)/$@

uvm_dpi.so:
	$(CXX) $(CFLAGS) -Bsymbolic $(UVM_HOME)/src/dpi/uvm_dpi.cc -o $(PLATFORM)/$(ARCH)/$@

clean:
	rm -rf $(PLATFORM)/$(ARCH)/*.so

.PHONY: all clean
