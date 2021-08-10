#!/bin/sh

rm -rf INCA_libs

while getopts d:t: opt
do
	case ${opt} in
	d)
		DESIGN=${OPTARG};;
	t)
		SIM_CLOCK=${OPTARG};;
	\?)
		echo "unrecognized option";
		exit 1;;
	esac
done

SIM_CLOCK=${SIM_CLOCK:=4000};

TEST_BENCH="test_riscv.v"

sleep 1;

DW_DIR="/home/vdec/synopsys/syn-H-2013.03-SP2/dw/sim_ver/";

${VERILOG:=ncverilog} \
	+define+FAST_FUNC\
	+define+no_macro_msg\
	+define+RTLSIM\
	+define+SIM_CLOCK=${SIM_CLOCK} \
	+define+BITSTRFILE=\"$1\" \
	+incdir+${DW_DIR} \
	+libext+.v \
	+licq \
	+turbo+3 \
	+nc64bit \
	+loadpli1=/home/vdec/synopsys/icc-Z-2007.03-SP4/suse64/power/vpower/libvpower.so:saifpli_bootstrap \
	+access+rw \
	${TEST_BENCH} \
	chip.v \
	./mem/dconf.v \
	./base/rv32i.v \
	./base/alu.v \
	./base/rfile.v \
	./base/imem.v \
	C55DDC_GS01GPIO.v \
	BLE.v \
	CB_R.v \
	CB_T.v \
	CONF_FF.v \
	CONF_FF_BLE.v \
	CONF_FF_CB.v \
	CONF_FF_IOB.v \
	CONF_FF_LCB.v \
	CONF_FF_SB.v \
	FPGA.v \
	CONF_CTRL.v \
	COUNTER.v \
	CRC32.v \
	DEF.v \
	IR.v \
	STATE_CTRL.v \
	TR.v \
	CHIP_CORE.v \
	IOB.v \
	IOB_ORA.v \
	IOE.v \
	LB.v \
	LCB.v \
	MUX7.v \
	MUX8.v \
	MUX16.v \
	SB.v \
	SCAN_FF.v \
	SLM5_4_0000.v \
	TILE.v \
	/home/vdec/synopsys/syn-H-2013.03-SP2/dw/sim_ver/DW_rbsh.v

