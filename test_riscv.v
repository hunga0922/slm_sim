//
// MAC execution chip : test bench
//
// Ver 1.00	1998-03-27 Initial version
// Ver 2.00	2013-05-03 Kumamoto Univ. version
// Coding by Masahiro IIDA
//
`delay_mode_zero
`timescale 1ns/1ns
`include "def.h"
module TestCHIP;

wire TCK;
wire TDI;
reg [31:0] iodir0, iodir1, ioout0, ioout1;
wire [31:0] ioin0, ioin1;
reg tdireg;
reg CLK;
wire CONF_EL;
reg conf_elreg;
wire CONF_RESETL;
reg conf_resetlreg;
reg RESETL;
reg breakrr;
wire cstart, breakr;
wire cbreak, scanreq ;
wire  SCAN_MODE;
wire [15:0] FPGA_IO_N, FPGA_IO_E, FPGA_IO_S, FPGA_IO_W;
wire [`DATA_W-1:0] ddataout, ddatain, ddatain_m, ddatain_i ;
wire [`DATA_W-1:0] iaddr;
wire [`DATA_W-1:0] daddr;
wire [`DATA_W-1:0] idata;
wire we, mwe, ecall_op;
wire TDO;
wire ERRL;
wire CONF_MODE;
wire [7:0] STATE;
wire [16:0] MCOUNT;

assign FPGA_IO_S[0] = (iodir0[0]==1)?ioout0[0]:1'bz;
assign FPGA_IO_S[1] = (iodir0[1]==1)?ioout0[1]:1'bz;
assign FPGA_IO_S[2] = (iodir0[2]==1)?ioout0[2]:1'bz;
assign FPGA_IO_S[3] = (iodir0[3]==1)?ioout0[3]:1'bz;
assign FPGA_IO_S[4] = (iodir0[4]==1)?ioout0[4]:1'bz;
assign FPGA_IO_S[5] = (iodir0[5]==1)?ioout0[5]:1'bz;
assign FPGA_IO_S[6] = (iodir0[6]==1)?ioout0[6]:1'bz;
assign FPGA_IO_S[7] = (iodir0[7]==1)?ioout0[7]:1'bz;
assign FPGA_IO_S[8] = (iodir0[8]==1)?ioout0[8]:1'bz;
assign FPGA_IO_S[9] = (iodir0[9]==1)?ioout0[9]:1'bz;
assign FPGA_IO_S[10] = (iodir0[10]==1)?ioout0[10]:1'bz;
assign FPGA_IO_S[11] = (iodir0[11]==1)?ioout0[11]:1'bz;
assign FPGA_IO_S[12] = (iodir0[12]==1)?ioout0[12]:1'bz;
assign FPGA_IO_S[13] = (iodir0[13]==1)?ioout0[13]:1'bz;
assign FPGA_IO_S[14] = (iodir0[14]==1)?ioout0[14]:1'bz;
assign FPGA_IO_S[15] = (iodir0[15]==1)?ioout0[15]:1'bz;
assign FPGA_IO_E[0] = (iodir0[16]==1)?ioout0[0]:1'bz;
assign FPGA_IO_E[1] = (iodir0[17]==1)?ioout0[1]:1'bz;
assign FPGA_IO_E[2] = (iodir0[18]==1)?ioout0[2]:1'bz;
assign FPGA_IO_E[3] = (iodir0[19]==1)?ioout0[3]:1'bz;
assign FPGA_IO_E[4] = (iodir0[20]==1)?ioout0[4]:1'bz;
assign FPGA_IO_E[5] = (iodir0[21]==1)?ioout0[5]:1'bz;
assign FPGA_IO_E[6] = (iodir0[22]==1)?ioout0[6]:1'bz;
assign FPGA_IO_E[7] = (iodir0[23]==1)?ioout0[7]:1'bz;
assign FPGA_IO_E[8] = (iodir0[24]==1)?ioout0[8]:1'bz;
assign FPGA_IO_E[9] = (iodir0[25]==1)?ioout0[9]:1'bz;
assign FPGA_IO_E[10] = (iodir0[26]==1)?ioout0[10]:1'bz;
assign FPGA_IO_E[11] = (iodir0[27]==1)?ioout0[11]:1'bz;
assign FPGA_IO_E[12] = (iodir0[28]==1)?ioout0[12]:1'bz;
assign FPGA_IO_E[13] = (iodir0[29]==1)?ioout0[13]:1'bz;
assign FPGA_IO_E[14] = (iodir0[30]==1)?ioout0[14]:1'bz;
assign FPGA_IO_E[15] = (iodir0[31]==1)?ioout0[15]:1'bz;

assign FPGA_IO_N[0] = (iodir1[0]==1)?ioout1[0]:1'bz;
assign FPGA_IO_N[1] = (iodir1[1]==1)?ioout1[1]:1'bz;
assign FPGA_IO_N[2] = (iodir1[2]==1)?ioout1[2]:1'bz;
assign FPGA_IO_N[3] = (iodir1[3]==1)?ioout1[3]:1'bz;
assign FPGA_IO_N[4] = (iodir1[4]==1)?ioout1[4]:1'bz;
assign FPGA_IO_N[5] = (iodir1[5]==1)?ioout1[5]:1'bz;
assign FPGA_IO_N[6] = (iodir1[6]==1)?ioout1[6]:1'bz;
assign FPGA_IO_N[7] = (iodir1[7]==1)?ioout1[7]:1'bz;
assign FPGA_IO_N[8] = (iodir1[8]==1)?ioout1[8]:1'bz;
assign FPGA_IO_N[9] = (iodir1[9]==1)?ioout1[9]:1'bz;
assign FPGA_IO_N[10] = (iodir1[10]==1)?ioout1[10]:1'bz;
assign FPGA_IO_N[11] = (iodir1[11]==1)?ioout1[11]:1'bz;
assign FPGA_IO_N[12] = (iodir1[12]==1)?ioout1[12]:1'bz;
assign FPGA_IO_N[13] = (iodir1[13]==1)?ioout1[13]:1'bz;
assign FPGA_IO_N[14] = (iodir1[14]==1)?ioout1[14]:1'bz;
assign FPGA_IO_N[15] = (iodir1[15]==1)?ioout1[15]:1'bz;
assign FPGA_IO_W[0] = (iodir1[16]==1)?ioout1[0]:1'bz;
assign FPGA_IO_W[1] = (iodir1[17]==1)?ioout1[1]:1'bz;
assign FPGA_IO_W[2] = (iodir1[18]==1)?ioout1[2]:1'bz;
assign FPGA_IO_W[3] = (iodir1[19]==1)?ioout1[3]:1'bz;
assign FPGA_IO_W[4] = (iodir1[20]==1)?ioout1[4]:1'bz;
assign FPGA_IO_W[5] = (iodir1[21]==1)?ioout1[5]:1'bz;
assign FPGA_IO_W[6] = (iodir1[22]==1)?ioout1[6]:1'bz;
assign FPGA_IO_W[7] = (iodir1[23]==1)?ioout1[7]:1'bz;
assign FPGA_IO_W[8] = (iodir1[24]==1)?ioout1[8]:1'bz;
assign FPGA_IO_W[9] = (iodir1[25]==1)?ioout1[9]:1'bz;
assign FPGA_IO_W[10] = (iodir1[26]==1)?ioout1[10]:1'bz;
assign FPGA_IO_W[11] = (iodir1[27]==1)?ioout1[11]:1'bz;
assign FPGA_IO_W[12] = (iodir1[28]==1)?ioout1[12]:1'bz;
assign FPGA_IO_W[13] = (iodir1[29]==1)?ioout1[13]:1'bz;
assign FPGA_IO_W[14] = (iodir1[30]==1)?ioout1[14]:1'bz;
assign FPGA_IO_W[15] = (iodir1[31]==1)?ioout1[15]:1'bz;

assign ioin0[0] = FPGA_IO_S[0] ;
assign ioin0[1] = FPGA_IO_S[1] ;
assign ioin0[2] = FPGA_IO_S[2] ;
assign ioin0[3] = FPGA_IO_S[3] ;
assign ioin0[4] = FPGA_IO_S[4] ;
assign  ioin0[5] = FPGA_IO_S[5] ;
assign  ioin0[6] = FPGA_IO_S[6] ;
assign  ioin0[7] = FPGA_IO_S[7] ;
assign  ioin0[8] = FPGA_IO_S[8] ;
assign  ioin0[9] = FPGA_IO_S[9] ;
assign  ioin0[10] = FPGA_IO_S[10];
assign  ioin0[11] = FPGA_IO_S[11] ;
assign  ioin0[12] = FPGA_IO_S[12] ;
assign  ioin0[13] = FPGA_IO_S[13] ;
assign  ioin0[14] = FPGA_IO_S[14] ;
assign  ioin0[15] = FPGA_IO_S[15] ;
assign  ioin0[16] = FPGA_IO_E[0] ;
assign  ioin0[17] = FPGA_IO_E[1] ;
assign  ioin0[18] = FPGA_IO_E[2] ;
assign  ioin0[19] = FPGA_IO_E[3] ;
assign  ioin0[20] = FPGA_IO_E[4] ;
assign  ioin0[21] = FPGA_IO_E[5] ;
assign  ioin0[22] = FPGA_IO_E[6] ;
assign  ioin0[23] = FPGA_IO_E[7] ;
assign  ioin0[24] = FPGA_IO_E[8] ;
assign  ioin0[25] = FPGA_IO_E[9] ;
assign  ioin0[26] = FPGA_IO_E[10] ;
assign  ioin0[27] = FPGA_IO_E[11] ;
assign  ioin0[28] = FPGA_IO_E[12] ;
assign  ioin0[29] = FPGA_IO_E[13] ;
assign  ioin0[30] = FPGA_IO_E[14] ;
assign  ioin0[31] = FPGA_IO_E[15] ;

assign ioin1[0] = FPGA_IO_N[0] ;
assign ioin1[1] = FPGA_IO_N[1] ;
assign ioin1[2] = FPGA_IO_N[2] ;
assign ioin1[3] = FPGA_IO_N[3] ;
assign ioin1[4] = FPGA_IO_N[4] ;
assign  ioin1[5] = FPGA_IO_N[5] ;
assign  ioin1[6] = FPGA_IO_N[6] ;
assign  ioin1[7] = FPGA_IO_N[7] ;
assign  ioin1[8] = FPGA_IO_N[8] ;
assign  ioin1[9] = FPGA_IO_N[9] ;
assign  ioin1[10] = FPGA_IO_N[10];
assign  ioin1[11] = FPGA_IO_N[11] ;
assign  ioin1[12] = FPGA_IO_N[12] ;
assign  ioin1[13] = FPGA_IO_N[13] ;
assign  ioin1[14] = FPGA_IO_N[14] ;
assign  ioin1[15] = FPGA_IO_N[15] ;
assign  ioin1[16] = FPGA_IO_W[0] ;
assign  ioin1[17] = FPGA_IO_W[1] ;
assign  ioin1[18] = FPGA_IO_W[2] ;
assign  ioin1[19] = FPGA_IO_W[3] ;
assign  ioin1[20] = FPGA_IO_W[4] ;
assign  ioin1[21] = FPGA_IO_W[5] ;
assign  ioin1[22] = FPGA_IO_W[6] ;
assign  ioin1[23] = FPGA_IO_W[7] ;
assign  ioin1[24] = FPGA_IO_W[8] ;
assign  ioin1[25] = FPGA_IO_W[9] ;
assign  ioin1[26] = FPGA_IO_W[10] ;
assign  ioin1[27] = FPGA_IO_W[11] ;
assign  ioin1[28] = FPGA_IO_W[12] ;
assign  ioin1[29] = FPGA_IO_W[13] ;
assign  ioin1[30] = FPGA_IO_W[14] ;
assign  ioin1[31] = FPGA_IO_W[15] ;

parameter CF_CK = 40;
always @(negedge CLK) begin
	conf_elreg <= CONF_EL;
	conf_resetlreg <= CONF_RESETL;
	tdireg <= TDI;
	breakrr <= breakr;
end

CHIP CHIP(
	.TDI(tdireg),
    .TCK(CLK),
    .CLK(CLK),
    .CONF_EL(conf_elreg),
    .CONF_RESETL(conf_resetlreg),
    .RESETL(RESETL),
    .BREAK(breakrr),
    .SCAN_MODE(SCAN_MODE), 
    .FPGA_IO_N(FPGA_IO_N),
    .FPGA_IO_E(FPGA_IO_E),
    .FPGA_IO_S(FPGA_IO_S),
    .FPGA_IO_W(FPGA_IO_W),

	.TDO(TDO),
    .ERRL(ERRL),
    .CONF_MODE(CONF_MODE),
/*    .FPGA_IO_N_OUT(FPGA_IO_N_OUT),
    .FPGA_IO_E_OUT(FPGA_IO_E_OUT),
    .FPGA_IO_S_OUT(FPGA_IO_S_OUT),
    .FPGA_IO_W_OUT(FPGA_IO_W_OUT),
	.FPGA_IO_N_DIR(FPGA_IO_N_DIR),
    .FPGA_IO_E_DIR(FPGA_IO_E_DIR),
    .FPGA_IO_S_DIR(FPGA_IO_S_DIR),
    .FPGA_IO_W_DIR(FPGA_IO_W_DIR), */
    .STATE(STATE),
    .MCOUNT(MCOUNT)
//    .MODE_STATE(MODE_STATE),
//    .CS(CS)
);

dconf dmem0 (
	.clk (CLK),
	.rst_n (RESETL),
	.cstart (cstart),
	.cbreak (cbreak),
	.scanreq(scanreq),
	.scanmode(SCAN_MODE),
	.a (daddr[17:2]),
	.rd (ddatain_m),
	.wd0 (ddataout[7:0]), 
	.wd1 (ddataout[15:8]),
	.wd2 (ddataout[23:16]),
	.wd3 (ddataout[31:24]),
	.we0(mwe),
	.we1(mwe),
	.we2(mwe),
	.we3(mwe),
	.tdi(TDI),
	.tdo(TDO),
	.conf_el(CONF_EL),
	.conf_resetl(CONF_RESETL),
	.breakr(breakr)
);
assign ddatain_i = {6'b0,MCOUNT, ERRL, SCAN_MODE, STATE};
assign cstart = daddr == `CSTART_ADD & we;
assign cbreak = daddr == `BREAK_ADD & we;
assign scanreq = daddr == `SCAN_ADD & we;
assign ddatain = daddr == `CIN_ADD ? ddatain_i: 
					daddr==	`DIR0_ADD ? iodir0: 
					daddr==	`DIR1_ADD ? iodir1: 
					daddr==	`IOOUT0_ADD ? ioout0: 
					daddr==	`IOOUT1_ADD ? ioout1: 
					daddr==	`IOIN0_ADD ? ioin0: 
					daddr==	`IOIN1_ADD ? ioin1: 
							ddatain_m;

always @(posedge CLK or negedge RESETL) begin
	if(!RESETL)	iodir0 <= 0;	
	else if(daddr == `DIR0_ADD & we) iodir0 <= ddataout;
end
always @(posedge CLK or negedge RESETL) begin
	if(!RESETL)	iodir1 <= 0;	
	else if(daddr == `DIR1_ADD & we) iodir1 <= ddataout;
end
always @(posedge CLK or negedge RESETL) begin
	if(!RESETL)	ioout0 <= 0;	
	else if(daddr == `IOOUT0_ADD & we) ioout0 <= ddataout;
end
always @(posedge CLK or negedge RESETL) begin
	if(!RESETL)	ioout1 <= 0;	
	else if(daddr == `IOOUT1_ADD & we) ioout1 <= ddataout;
end

always @(posedge CLK or negedge RESETL) begin
	if(daddr == `PRINT_ADD & we) begin 
		$display("data:%h",ddataout);
		$finish; 
		end
end

assign mwe = (daddr[31:20]==12'h0)& we;

rv32i rv32i_1(.clk(CLK), .rst_n(RESETL), 
	.instr(idata),
	.readdata(ddatain),
	.pc(iaddr),
	.aluresult(daddr),
	.writedata(ddataout), 
	.we(we), 
	.ecall_op(ecall_op) );

imem imem_1(.a(iaddr[17:2]),
	.rd(idata) );

always
begin			// 50 MHz
  #(CF_CK/2) CLK = 1;
  #(CF_CK/2) CLK = 0;
end


// I/O assign
//`include "dp_8_slm.iomap"


initial
begin
//$dumpfile("TestCHIP_DP.vcd");
//$dumpvars(0,TestCHIP);
$shm_open("./TST_CHIP_RISCV");
$shm_probe("AC");

 RESETL = 0;
 CLK = 0;
 // for coverage
 #CF_CK
 #CF_CK
 RESETL = 1;
 #CF_CK
 #CF_CK
 #CF_CK
 #CF_CK

//`include "./../../../slm_bitstream/3.routing/result/dp20200901/araki/seed0/dp_8_slm_araki.bitstream.MS"
//`include "./dp_8_slm.bitstream.MS"
// if (ERRL == 1'b0)
//	$finish; // retention
 #CF_CK
// CONF_EL = 1'b0;

 
//`include "./dp_8_slm.normal.MS"

   #(CF_CK*14900*8);
   #(CF_CK*14900*8);
//   #(CF_CK*256*256);
 //$dumpflush;
 
  //$dumpflush;
 $finish;

end

// clock gen.(1) for CPU


endmodule
