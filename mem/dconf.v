`include "def.h"
`define SN 6
`define IDLE_BIT 0
`define CSET_BIT 1
`define C8_BIT 2
`define NORM_BIT 3
`define CSETB_BIT 4
`define SCANIN_BIT 5

`define IDLE `SN'b1 <<`IDLE_BIT   //1
`define CSET `SN'b1 <<`CSET_BIT   //2
`define C8 `SN'b1 <<`C8_BIT   //4
`define NORM `SN'b1 <<`NORM_BIT   //8
`define CSETB `SN'b1 <<`CSETB_BIT   //16
`define SCANIN `SN'b1 <<`SCANIN_BIT   //32

module dconf (
 input clk, rst_n, cstart, cbreak, scanreq,
 input [`MADDR-1:0] a,
 input tdo,
 output [`BDATA*4-1:0] rd,
 input [`BDATA-1:0] wd0, wd1, wd2, wd3,
 input  we0,we1,we2,we3,
 output tdi, conf_el, conf_resetl,
 output breakr, scanmode);

 	wire [`MADDR-1:0] ma;
	reg [13:0] confa;
	reg [2:0] count;
	reg [7:0] mbuf, mbufr;
	reg [7:0] scan_a;
	wire [7:0] mbufw;
	reg [`BDATA-1:0] mem[0:`MSIZE-1];
	reg [`SN-1:0] stat;
	reg sset;
 assign conf_resetl = !stat[`CSET_BIT];
 assign conf_el = stat[`IDLE_BIT]|stat[`CSET_BIT]|stat[`C8_BIT]|stat[`CSETB_BIT]|stat[`SCANIN_BIT];
	assign ma = stat[`IDLE_BIT]|stat[`NORM_BIT] ? a: 
				stat[`SCANIN_BIT]? {8'hff,scan_a}: confa;

	assign  rd =  {mem[ma+3], mem[ma+2], mem[ma+1], mem[ma]};
	assign tdi=mbuf[7-count];
	assign breakr = stat[`CSETB_BIT];
	assign scanmode = stat[`SCANIN_BIT];

	always @(posedge clk)  begin
		if(stat[`NORM_BIT]) begin
			if(we0) mem[ma] <= wd0;
			if(we1) mem[ma+1] <= wd1;
			if(we2) mem[ma+2] <= wd2;
			if(we3) mem[ma+3] <= wd3; end
		else if(stat[`SCANIN_BIT]) 
			if(sset)
				mem[ma] <= mbufr;
	end

	assign		mbufw = mem[ma];
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) sset <=0;
		else if( stat[`SCANIN_BIT]& (count==7) )
			sset <= 1;
		else sset <=0;
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) mbuf <= 0;
		else if( stat[`CSET_BIT] | stat[`CSETB_BIT] | stat[`C8_BIT] & (count ==7) )
			mbuf <= mbufw;
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) mbufr <= 0;
		else if( stat[`SCANIN_BIT] )
			mbufr[count] <= tdo;
	end
		
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			stat <= `IDLE;
			count <= 0;
			confa <= 0; end
		else 
			case(stat)
			`IDLE: if(cstart) 
				stat <= `CSET;
			`CSET: begin
				stat <= `C8;
				count <= 0;
				confa <= 1; end
			`C8: if(confa == 14796) stat <= `NORM;
				 else begin
				 	if(count==7) begin
						confa <= confa+1;
						count <= 0;
					end
					else count <= count+1;
				end
			`NORM: if(cbreak) begin
					stat <= `CSETB;
					count <=0;
					confa <= 0; end
				else if(scanreq) begin
					stat <= `SCANIN;
					count <=0;
					scan_a <= 0;
				end
			`CSETB: begin
				stat <=`C8;
				count <= 0;
				confa <= 1; end
			`SCANIN: 
				if((scan_a==148)&(count==7))
					stat <= `NORM;
				else if(count==7) begin
					scan_a <= scan_a+1;
					count <= 0; end
				else
					count <= count+1;
			endcase
	end

	initial
      begin
           $readmemb("out.dat", mem);
    end


endmodule
