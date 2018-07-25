LIBS_NAME = stablelibs
#MAKE_LIBS = -nclibdirpath . -nclibdirname INCA_${LIBS_NAME} -makelib ${LIBS_NAME} -endlib
MAKE_LIBS = -nclibdirname INCA_${LIBS_NAME}
LOAD_LIBS = -reflib INCA_${LIBS_NAME}/worklib

COMMON_FLAGS = -64bit -sv -uvm 
NCVIP_FLAGS = -c -timescale 100ps/100ps
NCVLOG_FLAGS = -c -define LOCAL_SIM -timescale 100ps/100ps
NCSIM_FLAGS = -R

all: ncvlog ncsim

nclibs:
	irun ${MAKE_LIBS} ${COMMON_FLAGS} ${NCVIP_FLAGS} -f stablelibs.f | tee ncvlog.log

ncvlog:
	irun ${LOAD_LIBS} ${COMMON_FLAGS} ${NCVLOG_FLAGS} -f rtl.f -f vip.f -f env.f | tee ncvlog.log

ncsim:
	irun ${COMMON_FLAGS} ${NCSIM_FLAGS}

clear:
	rm -rf INCA_libs *.log

clean:
	rm -rf INCA_libs INCA_${LIBS_NAME} *.log

.PHONY: all clean clear nclibs ncvlog ncsim
